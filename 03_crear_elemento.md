# Crear elementos con Ionic

## Configuración de Yii2

1. Revisamos que exista el modelo User, con el array **$users**, el valor más importante es ***accessToken***

    [Rest Autenticación](https://www.yiiframework.com/doc/guide/2.0/es/rest-authentication)

2. Modificamos el archivo **config > web.php**

    * Configura el componente user de la aplicación:
        1. Define la propiedad **enableSession** como false.
        2. Define la propiedad **loginUrl** como null para mostrar un error HTTP 403 en vez de redireccionar a la pantalla de login.

    ```php
    'user' => [
        'identityClass'   => 'app\models\User',
        'enableAutoLogin' => true,
        'enableSession'   => false,
        'loginUrl'        => null
    ],
    ```

    * Modificamos el lenguaje`
    
    `'language' => 'es-Es',`

3. Especificamos el método de autenticación, configurando el comportamiento (behavior) authenticator en tus clases de controladores REST..

    ```php
    public function behaviors()
    {
        $behaviors = parent::behaviors();

        unset($behaviors['authenticator']);

        $behaviors['corsFilter'] = [
            'class' => \yii\filters\Cors::className(),
            'cors' => [
                'Origin'                           => ['http://localhost:8100','http://localhost:8101'],
                'Access-Control-Request-Method'    => ['GET', 'POST', 'PUT', 'DELETE'],
                'Access-Control-Request-Headers'   => ['*'],
                'Access-Control-Allow-Credentials' => true,
                'Access-Control-Max-Age'           => 600
            ]
        ];

        $behaviors['authenticator'] = [
            'class' => CompositeAuth::className(),
            'authMethods' => [
                HttpBearerAuth::className(),
            ],
            'except' => ['index', 'view']
        ];

        return $behaviors;
    }
    ```

    * **unset($behaviors['authenticator']);** eliminamos el authenticator por defecto.

    * Agregamos el nuevo authenticator donde la propiedad **except** desactiva la autentificación.

4. Agregamos el siguiente código

    `public $enableCsrfValidation = false;`

## Configuración en Ionic

1. Agregamos en el **page.html** el botón que nos redigirá al formulario

    ```html
    <ion-fab slot="fixed" vertical="bottom" horizontal="center">
        <ion-fab-button (click)="new()">
            <ion-icon name="add"></ion-icon>
        </ion-fab-button>
    </ion-fab>
    ```

2. Creamos la función en el **page.ts**

    ```typescript
    async new() {
        const paginaModal = await this.modalCtrl.create({
            component: NewPage,
            breakpoints : [0, 0.3, 0.5, 0.95],
            initialBreakpoint: 0.95
        });
        await paginaModal.present();
        paginaModal.onDidDismiss().then((data) => {
            this.cargarAlumnos();
        });
    }
    ```
    * **NewPage** es el nombre de la clase de la página donde estará nuestro formulario

3. Modificamos en el **page.ts** donde estará nuestro formulario, recuerda que debes agregar la ***s***

    * Declaramos todas nuestras variables

    ```typescript
    baseUrl:string = "http://clases.test/user-alumnos"
    carreraUrl:string = "http://clases.test/sws-carrera/"

    public alumno!: FormGroup;

    sexos = [
        {'sex_id' : 1, 'sex_sexo' : 'Masculino'},
        {'sex_id' : 2, 'sex_sexo' : 'Femenino'},
    ];

    carreras:any = [];
    ```

4. Creamos nuestros mensajes de validación

    ```typescript
     mensajes_validacion:any = {
        'alu_matricula' : [
            {type : 'required' , message : 'Matrícula requerida.'},
            {type : 'minLength', message : 'Matrícula debe contener al menos 8 caracteres.'},
            {type : 'maxLength', message : 'Matrícula no debe contener más de 10 caracteres.'},
            {type : 'pattern'  , message : 'Dígita una matrícula valida.'},
        ],
        'alu_nombre' : [
            {type : 'required' , message : 'Nombre(s) requeridos.'},
        ],
        'alu_paterno' : [
            {type : 'required' , message : 'Apellido Paterno requerido.'},
        ],
        'alu_materno' : [
            {type : 'required' , message : 'Apellido Materno requerido.'},
        ],
        'alu_semestre' : [
            {type : 'required' , message : 'Semestre requerido.'},
            {type : 'min', message : 'Semestre mínimo 1ro.'},
            {type : 'max', message : 'Semestre máximo 15vo.'},
        ],
        'alu_sexo' : [
            {type : 'required' , message : 'Sexo requerido.'},
        ],
        'alu_fkcarrera' : [
            {type : 'required' , message : 'Carrera requerida.'},
        ],
    }
    ```

5. Configuramos el constructor y el ngOnInit

    ```typescript
    constructor(
        private formBuilder : FormBuilder,
        private alert : AlertController,
        private modalCtrl: ModalController
    ) { }
    
    ngOnInit() {
        this.cargarCarreras();
        this.formulario();
    }
    ```

6. Creamos el método **cargarCarreras()**

    ```typescript
    async cargarCarreras() {
        const response = await axios({
            method: 'get',
            url : this.carreraUrl,
            withCredentials: true,
            headers: {
                'Accept': 'application/json'
            }
        }).then( (response) => {
            this.carreras = response.data;
        }).catch(function (error) {
            console.log(error);     
        });
    }
    ```

7. Creamos el método formulario, nos apoyamos de los [Validators](https://angular.io/api/forms/Validators) de Angular

    ```typescript
    private formulario() {
        this.alumno = this.formBuilder.group({
        alu_matricula : ['', Validators.compose([
            Validators.required,
            Validators.minLength(8),
            Validators.maxLength(10),
            Validators.pattern("^[1|2][0-9]{7,9}$")
        ])],
        alu_nombre: ['', [Validators.required]],
        alu_paterno: ['',[Validators.required]],
        alu_materno: ['',[Validators.required]],
        alu_semestre: ['', Validators.compose([
            Validators.min(1),
            Validators.max(15),
            Validators.required,
        ])],
        alu_sexo: ['', [Validators.required]],
        alu_fkcarrera: ['', [Validators.required]],
        })
    }
    ```

8. Creamos la función que con ayuda de axios no permitirá la creación de nuevos elementos

    ```typescript
    async guardarDatos() {
        try {
        const alumno = this.alumno?.value;
        const response = await axios({
            method: 'post',
            url : this.baseUrl,
            data: alumno,
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer 100-token'
            }
        }).then( (response) => {
            if(response?.status == 201) {
                this.alertGuardado(response.data.alu_matricula, 'El alumno con matricula ' + response.data.alu_matricula + ' ha sido registrada');
            }
        }).catch( (error) => {
            if(error?.response?.status == 422) {
                this.alertGuardado(alumno.alu_matricula, error?.response?.data[0]?.message, "Error");
            }     
        });
        } catch(e){
            console.log(e);
        }
    }
    ```

9. Creamos el método que permitirá la validación del formulario en tiempo real

    ```typescript
    public getError(controlName: string) {
        let errors: any[] = [];
        const control = this.alumno.get(controlName);
        if (control?.touched && control?.errors != null) {
            errors = JSON.parse(JSON.stringify(control?.errors));
        }
        return errors;
    }
    ```

10. Creamos un método para reutilizar un alert

    ```typescript
    private async alertGuardado(matricula: String, msg = "",  subMsg= "Guardado") {
        const alert = await this.alert.create({
            header: 'Alumno',
            subHeader: subMsg,
            message: msg,
            cssClass: 'alert-center',
            buttons: [
                {
                    text: 'Continuar',
                    role: 'cancel',
                },
                {
                    text: 'Salir',
                    role: 'confirm',
                    handler: () => {
                        this.modalCtrl.dismiss();
                    },
                },
            ],
        });
        await alert.present();
    }
    ```
    
11. Modificamos el ***page.html***

    ```html
    <ion-header>
        <ion-toolbar color="personalizado">
            <ion-title class="ion-text-center">Nuevo Alumno</ion-title>
        </ion-toolbar>
    </ion-header>

    <ion-content>
        <form [formGroup]="alumno" (ngSubmit)="guardarDatos()">
            <ion-grid>
                <ion-row>
                    <ion-col size="12">
                        <ion-item>
                            <ion-label position="floating" color="primary">Matrícula</ion-label>
                            <ion-input type="text" formControlName="alu_matricula" class="form-control"></ion-input>
                        </ion-item>
                        <div id="note" *ngFor="let validation of mensajes_validacion.alu_matricula">
                            <ion-note color="danger" *ngIf="getError('alu_matricula')[(validation.type)]">
                                <ion-icon name="information-circle-outline"></ion-icon> {{ validation.message }}
                            </ion-note>
                        </div>
                    </ion-col>
                    <ion-col size="12">
                        <ion-item>
                            <ion-label position="floating" color="primary">Nombre(s)</ion-label>
                            <ion-input type="text" formControlName="alu_nombre" class="form-control"></ion-input>
                        </ion-item>
                        <div id="note" *ngFor="let validation of mensajes_validacion.alu_nombre">
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
                        <div id="note" *ngFor="let validation of mensajes_validacion.alu_paterno">
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
                        <div id="note" *ngFor="let validation of mensajes_validacion.alu_materno">
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
                        <div id="note" *ngFor="let validation of mensajes_validacion.alu_semestre">
                            <ion-note color="danger" *ngIf="getError('alu_semestre')[(validation.type)]">
                                <ion-icon name="information-circle-outline"></ion-icon> {{ validation.message }}
                            </ion-note>
                        </div>
                    </ion-col>
                    <ion-col size="12">
                        <ion-item>
                            <ion-label position="floating" color="primary">Sexo</ion-label>
                            <ion-select formControlName="alu_sexo" class="form-control">
                                <ion-select-option *ngFor="let sexo of sexos" value="{{sexo.sex_id}}">
                                    {{ sexo.sex_sexo }}
                                </ion-select-option>
                            </ion-select>
                        </ion-item>
                        <div id="note" *ngFor="let validation of mensajes_validacion.alu_sexo">
                            <ion-note color="danger" *ngIf="getError('alu_sexo')[(validation.type)]">
                                <ion-icon name="information-circle-outline"></ion-icon> {{ validation.message }}
                            </ion-note>
                        </div>
                    </ion-col>
                    <ion-col size="12">
                        <ion-item>
                            <ion-label position="floating" color="primary">Carrera</ion-label>
                            <ion-select formControlName="alu_fkcarrera" class="form-control">
                                <ion-select-option *ngFor="let carrera of carreras" value="{{carrera.CAR_CVE}}">
                                    {{ carrera.CAR_NOM }}
                                </ion-select-option>
                            </ion-select>
                        </ion-item>
                        <div id="note" *ngFor="let validation of mensajes_validacion.alu_fkcarrera">
                            <ion-note color="danger" *ngIf="getError('alu_fkcarrera')[(validation.type)]">
                                <ion-icon name="information-circle-outline"></ion-icon> {{ validation.message }}
                            </ion-note>
                        </div>
                    </ion-col>
                    <ion-col size="12">
                        <p class="ion-text-center">
                            <ion-button type="submit" [disabled]="!alumno.valid">Guardar</ion-button>
                        </p>
                    </ion-col>
                </ion-row>
            </ion-grid>
        </form>
    </ion-content>
    ```

12. Agregamos en el archivo **module.ts** el módulo ***ReactiveFormsModule*** para el funcionamiento de los Formularios Reactivos

    * La importación del módulo

    ```typescript
    import { FormsModule, ReactiveFormsModule } from '@angular/forms';
    ```

    * Se agrega el módulo

    ```typescript
    @NgModule({
    imports: [
        CommonModule,
        FormsModule,
        IonicModule,
        NewPageRoutingModule,
        ReactiveFormsModule
    ],
    declarations: [NewPage]
    })
    ```
