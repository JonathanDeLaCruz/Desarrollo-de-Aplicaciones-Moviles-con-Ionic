# Creación de inicio de sesión y registro de usuarios

## Modificaciones en Yii2

1. Agregamos el **actionLogin**
```php
public function actionLogin() {
    $token = '';
    $model = new LoginForm();
    $model->load(Yii::$app->getRequest()->getBodyParams(), '');
    if($model->login()) {
        $token = User::findOne(['username' => $model->username])->auth_key;
    }
    return $token;
}
```

2. Agregamos el **actionRegistrar**
```php
public function actionRegistrar() { 
    $token = '';
    $model = new RegistroForm();
    $model->load(Yii::$app->getRequest()->getBodyParams(), '');
    $user   = new User();
    $alumno = new UserAlumno();
    $user->username        = $model->username;
    $user->password        = $model->password;
    $user->status          = User::STATUS_ACTIVE;
    $user->email_confirmed = 1;
    if($user->save()) {
        $alumno->alu_matricula = $model->username;
        $alumno->alu_nombre    = $model->alu_nombre;
        $alumno->alu_paterno   = $model->alu_paterno;
        $alumno->alu_materno   = $model->alu_materno;
        $alumno->alu_semestre  = $model->alu_semestre;
        $alumno->alu_sexo      = $model->alu_sexo;
        $alumno->alu_fkcarrera = 0;
        if($alumno->save()) {
            $token = $user->auth_key;
        }
    } else {
        return $user;
    }
    return $token;
}
```

3. Creamos el archivo **RegistroForm.php** dentro de la carpeta **models**
```php
namespace app\models;

use yii\base\Model;

class RegistroFrom extends Model
{
    public $username;
    public $password;
    public $alu_nombre;
    public $alu_paterno;
    public $alu_materno;
    public $alu_semestre;
    public $alu_sexo;

    public function rules() 
    {
        return [
            ['username', 'unique'],
            [['username', 'password', 'alu_nombre', 'alu_paterno', 'alu_materno', 'alu_semestre', 'alu_sexo'], 'required'],
            [['alu_semestre', 'alu_sexo'], 'integer'],
            [['username', 'password'], 'trim'],
            [['alu_nombre', 'alu_paterno', 'alu_materno', 'alu_semestre', 'alu_sexo'], 'string', 'max' => 40],
        ];
    }
}
```

4. Modificamos el archivo **web.php** 
- Cambiamos el array **user**
```php
'user' => [
    'class' => 'webvimark\modules\UserManagement\components\UserConfig',
    'on afterLogin' => function ($event) {
        \webvimark\modules\UserManagement\models\UserVisitLog::newVisitor($event->identity->id);
    }
]
```

- Agregamos dos **extraPatterns**
```php
'POST login'     => 'login',
'POST registrar' => 'registrar',
```

- Agregamos el array de **modules**
```php
'modules' => [
    'user-management' => [
        'class' => 'webvimark\modules\UserManagement\UserManagementModule',
        'on beforeAction' => function(yii\base\ActionEvent $event) {
            if ($event->action->uniqueId === 'user-management/auth/login') {
                $event->action->controller->layout = 'loginLayout.php';
            }
        },
    ],
],
```

## Modificaciones en Ionic

1. Creamos el servicio de **login**

```ts
ionic g service services/login
```

2. Agregamos las variables necesarias
```ts
url:string  = `${environment.apiUrl}user-alumno/`;
headers:any = {'Content-Type': 'application/json'}; 
```

3. Agregamos los métodos necesarios
```ts
login(dataLogin: any): Observable<any> {
    const url = `${this.url}login`;
    return new Observable(observer => {
      axios.post(url, dataLogin, {
        withCredentials: true,
        headers: this.headers
      })
      .then(response => {
        observer.next(response);
        observer.complete();
      })
      .catch(error => {
        observer.error(error);
        observer.complete();
      });
    });
}

registrar(dataRegistrar: any): Observable<any> {
    const url = `${this.url}registrar`;
    return new Observable(observer => {
      axios.post(url, dataRegistrar, {
        withCredentials: true,
        headers: this.headers
      })
      .then(response => {
        observer.next(response);
        observer.complete();
      })
      .catch(error => {
        observer.error(error);
        observer.complete();
      });
    });
}
```

4. Creamos la page de **login**

- Contenido del **login.page.ts**
```ts
login!: FormGroup;

@ViewChild('passwordEyeRegister', { read: ElementRef }) passwordEye!: ElementRef;

passwordTypeInput = 'password';

validation_messages:any = {
    'username': [
        { type: 'required', message: 'Matrícula requerida.' },
        { type: 'minlength', message: 'Matrícula debe contener al menos 8 caracteres.' },
        { type: 'maxlength', message: 'Matrícula no puede contener más de 10 caracteres.' },
        { type: 'pattern', message: 'Dígita una matrícula valida' },
    ],
    'password': [
        { type: 'required', message: 'Contraseña requerida.' },
    ]
}

private buildForm() {
    this.login = this.formBuilder.group({
        username: ['', Validators.compose([
            Validators.maxLength(10),
            Validators.minLength(8),
            Validators.pattern("^[0|1|2][0-9]{7,9}$"),
            Validators.required
        ])],
        password: ['', Validators.compose([
            Validators.maxLength(15)
        ])],
    });
}

  async submitLogin() {
    localStorage.clear();
    const loginData = this.login?.value;
    try {
        await this.loginService.login(loginData).subscribe(
            async response => {
                if (response?.status == 200 && response?.data !== '') {
                    await localStorage.setItem('token', response?.data);
                    localStorage.setItem('sesion', 'login');
                    localStorage.setItem('username', loginData.username);
                    this.router.navigate(['/tabs']);
                } else if( response?.data === '') {
                    this.alertError();
                }
            },
            error => {
                console.log(error);
            }
        );
    } catch (error) {
        console.log(error);
    }
}

async alertError() {
    const alert = await this.alertCtrl.create({
        header: 'Importante',
        subHeader: 'Error',
        message: 'Nombre de usuario o contraseña incorrecta.',
        cssClass: 'alert-center',
        buttons: ['Corregir'],
    });
    await alert.present();
}

getError(controlName: string) {
    let errors: any[] = [];
    const control = this.login.get(controlName);
    if (control!.touched && control!.errors != null) {
        errors = JSON.parse(JSON.stringify(control!.errors));
    }
    return errors;
}

registrar() {
    this.router.navigate(['/registro']);
}

togglePasswordMode() {
    const e = window.event;
    e!.preventDefault();
    this.passwordTypeInput = this.passwordTypeInput === 'text' ? 'password' : 'text';
    const nativeEl = this.passwordEye.nativeElement.querySelector('input');
    const inputSelection = nativeEl.selectionStart;
    nativeEl.focus();
    setTimeout(() => {
        nativeEl.setSelectionRange(inputSelection, inputSelection);
    }, 1);
}
```

- Contenido del **login.page.html**
```html
<ion-header>
  <ion-toolbar color="primary">
    <ion-title class="ion-text-center">Inicio de Sesión</ion-title>
  </ion-toolbar>
</ion-header>

<ion-content>
  <form [formGroup]="login" (ngSubmit)="submitLogin()">
    <ion-grid>
      <ion-row>
        <ion-col size="12">
          <ion-item>
            <ion-label position="floating" color="primary">Matrícula</ion-label>
            <ion-input type="text" formControlName="username" class="form-control"></ion-input>
          </ion-item>
          <div id="note" *ngFor="let validation of validation_messages.username">
            <ion-note color="danger" *ngIf="getError('username')[(validation.type)]">
              <ion-icon name="information-circle-outline"></ion-icon> {{validation.message }}
            </ion-note>
          </div>
        </ion-col>
        <ion-col size="12">
          <ion-item>
            <ion-label position="floating" color="primary">Contraseña</ion-label>
              <ion-input #passwordEyeRegister [type]="passwordTypeInput" formControlName="password" clearOnEdit="false" class="form-control">
            </ion-input>
            <button slot="end" class="btn_eye_icon" (click)="togglePasswordMode()">
              <ion-icon [name]="(passwordTypeInput === 'text')?'eye-off':'eye'"></ion-icon>
            </button>
          </ion-item>
          <div id="note" *ngFor="let validation of validation_messages.password">
            <ion-note color="danger" *ngIf="getError('password')[(validation.type)]">
              <ion-icon name="information-circle-outline"></ion-icon> {{validation.message }}
            </ion-note>
          </div>
        </ion-col>
        <ion-col size="12">
          <p class="ion-text-center">
            <ion-button type="submit" [disabled]="!login.valid">Enviar</ion-button>
          </p>
        </ion-col>
      </ion-row>
    </ion-grid>
  </form>
</ion-content>

<ion-footer>
  <ion-button expand="full" (click)="registrar()">
    <ion-icon name="open-outline" slot="start"></ion-icon>
    Registrarme
  </ion-button>
</ion-footer>
```

5. Creamos la page de **registro**

- Contenido del **registro.page.ts**
```ts
public registro!: FormGroup;

@ViewChild('passwordEyeRegister', { read: ElementRef }) passwordEye!: ElementRef;

passwordTypeInput = 'password';

sexos = [
    { 'sex_id': '1', 'sex_sexo': 'Masculino' },
    { 'sex_id': '2', 'sex_sexo': 'Femenino' },
];

validation_messages:any = {
    'username': [
        { type: 'required', message: 'Matrícula requerida.' },
        { type: 'minlength', message: 'Matrícula debe contener al menos 8 caracteres.' },
        { type: 'maxlength', message: 'Matrícula no puede contener más de 10 caracteres.' },
        { type: 'pattern', message: 'Dígita una matrícula valida' },
    ],
    'password': [
        { type: 'required', message: 'Contraseña requerida.' },
        { type: 'minlength', message: 'Contraseña debe contener al menos 8 caracteres.' },
        { type: 'maxlength', message: 'Contraseña no puede contener más de 15 caracteres.' },
        { type: 'pattern', message: 'Dígita una contraseña valida' },
    ],
    'password_confirm': [
        { type: 'required', message: 'Contraseña requerida.' },
        { type: 'minlength', message: 'Contraseña debe contener al menos 8 caracteres.' },
        { type: 'maxlength', message: 'Contraseña no puede contener más de 15 caracteres.' },
        { type: 'pattern', message: 'Dígita una contraseña valida' },
        { type: 'notEquivalent', message: 'No coinciden las contraseñas' },
    ],
    'alu_nombre': [
        { type: 'required', message: 'Nombre(s) requerido(s).' },
    ],
    'alu_paterno': [
        { type: 'required', message: 'Apellido Paterno requerido.' },
    ],
    'alu_materno': [
        { type: 'required', message: 'Apellido Materno requerido.' },
    ],
    'alu_semestre': [
        { type: 'required', message: 'Semestre requerido.' },
        { type: 'min', message: 'Semestre mínimo 1ro.' },
        { type: 'max', message: 'Semestre máximo 15vo.' },
    ],
    'alu_sexo': [
        { type: 'required', message: 'Sexo requerido.' },
    ]
}

buildForm() {
    this.registro = this.formBuilder.group({
      username: ['', Validators.compose([
        Validators.maxLength(10),
        Validators.minLength(8),
        Validators.pattern("^[0|1|2][0-9]{7,9}$"),
        Validators.required
      ])],
      password: ['', Validators.compose([
        Validators.maxLength(15),
        Validators.minLength(8),
        Validators.pattern("^(?=.*[-!#$%&/()?¡_])(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{8,15}$"),
        Validators.required
      ])],
      password_confirm: ['', Validators.compose([
        Validators.maxLength(15),
        Validators.minLength(8),
        Validators.pattern("^(?=.*[-!#$%&/()?¡_])(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{8,15}$"),
        Validators.required
      ])],
      alu_nombre: ['', [Validators.required]],
      alu_paterno: ['', [Validators.required]],
      alu_materno: ['', [Validators.required]],
      alu_semestre: ['', Validators.compose([
        Validators.max(15),
        Validators.min(1),
        Validators.required
      ])],
      alu_sexo: ['', [Validators.required]]
    }, { validator: this.checkIfMatchingPasswords('password', 'password_confirm') });
  }

checkIfMatchingPasswords(passwordKey: string, passwordConfirmationKey: string) {
    return (group: FormGroup) => {
        let passwordInput = group.controls[passwordKey],
            passwordConfirmationInput = group.controls[passwordConfirmationKey];
        if (passwordInput.value !== passwordConfirmationInput.value) {
            return passwordConfirmationInput.setErrors({ notEquivalent: true })
        } else {
            return passwordConfirmationInput.setErrors(null);
        }
    }
}

async submitRegistrar() {
    localStorage.clear();
    const registrarData = this.registro?.value;
    try {
        await this.loginService.registrar(registrarData).subscribe(
            async response => {
                if (response?.status == 200 && response?.data !== '') {
                    await localStorage.setItem('token', response?.data);
                    localStorage.setItem('sesion', 'login');
                    localStorage.setItem('username', registrarData.username);
                    this.router.navigate(['/tabs/tab1']);
                } else if( response?.data === '') {
                    this.alertError();
                }
            },
            error => {
                if (error.status == 422) {
                    this.alertDuplicado();
                }
            }
        );
    } catch (error) {
        console.log(error);
    }
}

async alertError() {
    const alert = await this.alertCtrl.create({
        header: 'Importante',
        subHeader: 'Error',
        message: 'Nombre de usuario o contraseña incorrecta.',
        cssClass: 'alert-center',
        buttons: ['Corregir'],
    });
    await alert.present();
}

async alertDuplicado() {
    const alert = await this.alertCtrl.create({
        header: 'Importante',
        subHeader: 'Duplicado',
        message: 'La matricula ya se encuentra registrada',
        cssClass: 'alert-center',
        buttons: ['Corregir'],
    });
    await alert.present();
}

getError(controlName: string) {
    let errors: any[] = [];
    const control = this.registro.get(controlName);
    if (control!.touched && control!.errors != null) {
        errors = JSON.parse(JSON.stringify(control!.errors));
    }
    return errors;
}

login() {
    this.router.navigate(['/']);
}

togglePasswordMode() {
    const e = window.event;
    e!.preventDefault();
    this.passwordTypeInput = this.passwordTypeInput === 'text' ? 'password' : 'text';
    const nativeEl = this.passwordEye.nativeElement.querySelector('input');
    const inputSelection = nativeEl.selectionStart;
    nativeEl.focus();
    setTimeout(() => {
        nativeEl.setSelectionRange(inputSelection, inputSelection);
    }, 1);
}
```

- Contenido del **registro.page.html**
```ts
<ion-header>
  <ion-toolbar color="personalizado">
    <ion-buttons slot="start">
      <ion-button (click)="login()">
        <ion-icon name="arrow-back-circle-outline"></ion-icon>
      </ion-button>
    </ion-buttons>
    <ion-title class="ion-text-center">Registrarme</ion-title>
  </ion-toolbar>
</ion-header>

<ion-content>
  <form [formGroup]="registro" (ngSubmit)="submitRegistrar()">
    <ion-grid>
      <ion-row>
        <ion-col size="12">
          <ion-item>
            <ion-label position="floating" color="primary">Matrícula</ion-label>
            <ion-input type="text" formControlName="username" class="form-control"></ion-input>
          </ion-item>
          <div id="note" *ngFor="let validation of validation_messages.username">
            <ion-note color="danger" *ngIf="getError('username')[(validation.type)]">
              <ion-icon name="information-circle-outline"></ion-icon> {{validation.message }}
            </ion-note>
          </div>
        </ion-col>
        <ion-col size="12">
          <ion-item>
            <ion-label position="floating" color="primary">Contraseña</ion-label>
            <ion-input #passwordEyeRegister [type]="passwordTypeInput" formControlName="password" clearOnEdit="false" class="form-control"></ion-input>
            <button slot="end" class="btn_eye_icon" (click)="togglePasswordMode()">
              <ion-icon [name]="(passwordTypeInput === 'text')?'eye-off':'eye'"></ion-icon>
            </button>
          </ion-item>
          <div id="note" *ngFor="let validation of validation_messages.password">
            <ion-note color="danger" *ngIf="getError('password')[(validation.type)]">
              <ion-icon name="information-circle-outline"></ion-icon> {{ validation.message }}
            </ion-note>
          </div>
        </ion-col>
        <ion-col size="12">
          <ion-item>
            <ion-label position="floating" color="primary">Confirmar Contraseña</ion-label>
            <ion-input #passwordEyeRegister [type]="passwordTypeInput" formControlName="password_confirm" clearOnEdit="false" class="form-control"></ion-input>
            <button slot="end" class="btn_eye_icon" (click)="togglePasswordMode()">
              <ion-icon [name]="(passwordTypeInput === 'text')?'eye-off':'eye'"></ion-icon>
            </button>
          </ion-item>
          <div id="note" *ngFor="let validation of validation_messages.password_confirm">
            <ion-note color="danger" *ngIf="getError('password_confirm')[(validation.type)]">
              <ion-icon name="information-circle-outline"></ion-icon> {{ validation.message }}
            </ion-note>
          </div>
        </ion-col>
        <ion-col size="12">
          <ion-item>
            <ion-label position="floating" color="primary">Nombre(s)</ion-label>
            <ion-input type="text" formControlName="alu_nombre" class="form-control"></ion-input>
          </ion-item>
          <div id="note" *ngFor="let validation of validation_messages.alu_nombre">
            <ion-note color="danger" *ngIf="getError('alu_nombre')[(validation.type)]">
              <ion-icon name="information-circle-outline"></ion-icon> {{ validation.message }}
            </ion-note>
          </div>
        </ion-col>
        <ion-col size="12">
          <ion-item>
            <ion-label position="floating" color="primary">Apellido Paterno</ion-label>
            <ion-input type="text" formControlName="alu_paterno" class="form-control"></ion-input>
          </ion-item>
          <div id="note" *ngFor="let validation of validation_messages.alu_paterno">
            <ion-note color="danger" *ngIf="getError('alu_paterno')[(validation.type)]">
              <ion-icon name="information-circle-outline"></ion-icon> {{ validation.message }}
            </ion-note>
          </div>
        </ion-col>
        <ion-col size="12">
          <ion-item>
            <ion-label position="floating" color="primary">Apellido Materno</ion-label>
            <ion-input type="text" formControlName="alu_materno" class="form-control"></ion-input>
          </ion-item>
          <div id="note" *ngFor="let validation of validation_messages.alu_materno">
            <ion-note color="danger" *ngIf="getError('alu_materno')[(validation.type)]">
              <ion-icon name="information-circle-outline"></ion-icon> {{ validation.message }}
            </ion-note>
          </div>
        </ion-col>
        <ion-col size="12">
          <ion-item>
            <ion-label position="floating" color="primary">Semestre</ion-label>
            <ion-input type="number" formControlName="alu_semestre" class="form-control"></ion-input>
          </ion-item>
          <div id="note" *ngFor="let validation of validation_messages.alu_semestre">
            <ion-note color="danger" *ngIf="getError('alu_semestre')[(validation.type)]">
              <ion-icon name="information-circle-outline"></ion-icon> {{ validation.message }}
            </ion-note>
          </div>
        </ion-col>
        <ion-col size="12">
          <ion-item>
            <ion-label position="floating" color="primary">Sexo</ion-label>
            <ion-select formControlName="alu_sexo" class="form-control">
              <ion-select-option *ngFor="let sexo of sexos" value="{{sexo.sex_id}}">{{ sexo.sex_sexo }}</ion-select-option>
            </ion-select>
          </ion-item>
        <div id="note" *ngFor="let validation of validation_messages.alu_sexo">
          <ion-note color="danger" *ngIf="getError('alu_sexo')[(validation.type)]">
            <ion-icon name="information-circle-outline"></ion-icon> {{ validation.message }}
          </ion-note>
        </div>
        </ion-col>
        <ion-col size="12">
          <p class="ion-text-center">
            <ion-button type="submit" [disabled]="!registro.valid">Guardar</ion-button>
          </p>
        </ion-col>
      </ion-row>
    </ion-grid>
  </form>
</ion-content>
```

6. Modificamos el **app-routing.module.ts**
```ts
{
    path: '',
    loadChildren: () => import('./login/login.module').then(m => m.LoginPageModule)
},
```