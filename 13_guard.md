# Guards

## Configuración en Yii2

1. Creamos en la carpeta models el archivo **Permiso.php**
```php
namespace app\models;

use Yii;

/**
 * This is the model class for table "permiso".
 *
 * @property int $per_id ID
 * @property string $per_vista Nombre de la vista
 * @property string $per_rol Roles permitidos
 */
class Permiso extends \yii\db\ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return 'permiso';
    }

    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            [['per_vista', 'per_rol'], 'required'],
            [['per_vista'], 'string', 'max' => 100],
            [['per_rol'], 'string', 'max' => 150],
        ];
    }

    /**
     * {@inheritdoc}
     */
    public function attributeLabels()
    {
        return [
            'per_id' => 'ID',
            'per_vista' => 'Nombre de la vista',
            'per_rol' => 'Roles permitidos',
        ];
    }
}
```

2. Creamos en la carpeta controllers **PermisoController.php**
```php
namespace app\controllers;

use app\models\Permiso;
use webvimark\modules\UserManagement\models\User;
use yii\filters\auth\CompositeAuth;
use yii\filters\auth\HttpBearerAuth;
use yii\rest\ActiveController;

class PermisoController extends ActiveController
{
    public function behaviors()
    {
        $behaviors = parent::behaviors();
        unset($behaviors['authenticator']);
        $behaviors['corsFilter'] = [
            'class' => \yii\filters\Cors::class,
            'cors' => [
                'Origin'                           => ['http://localhost:8100'],
                'Access-Control-Request-Method'    => ['GET'],
                'Access-Control-Request-Headers'   => ['*'],
                'Access-Control-Allow-Credentials' => true,
                'Access-Control-Max-Age'           => 600
            ]
        ];
        $behaviors['authenticator'] = [
            'class' => CompositeAuth::class,
            'authMethods' => [
                HttpBearerAuth::class,
            ]
        ];
        return $behaviors;
    }

    public $enableCsrfValidation = false;
    public $modelClass = 'app\models\Permiso';

    public function actionListaPermisos($user = '')
    {
        $permitidas = [];
        $user = User::findOne(['auth_key' => $user]);
        if (isset($user)) {
            $userRoles = $user->roles;
            $permisos = Permiso::find()->all();
            foreach ($permisos as $p) {
                $rolesPermitidos = explode(',', $p->per_rol);

                foreach ($userRoles as $rol) {
                    $rolNombre = is_array($rol) ? $rol['name'] : $rol->name;
                    if (in_array($rolNombre, $rolesPermitidos)) {
                        $permitidas[] = $p->per_vista;
                        break;
                    }
                }
            }
        }
        return $permitidas;
    }
}
```

3. Agregamos la regla en el archivo **web.php**
```php
['class' => 'yii\web\UrlRule', 'pattern' => 'permisos/user/<text:.*>', 'route' => 'permiso/user'],
[
    'class'      => 'yii\rest\UrlRule',
    'controller' => 'permiso',
    'tokens' => [
        '{id}'  => '<id:\\d[\\d,]*>',
        '{rol}' => '<rol:\\w+>'
    ],
    'extraPatterns' => [
        'GET lista-permisos/{rol}' => 'lista-permisos/{rol}'
    ],
],
```

## Configuración en Ionic

1. Creamos el servicio de **permiso**

- Creamos el servicio
```ts
ionic g service services/permiso
```

- Agregamos las variables
```ts
url:string  = `${environment.apiUrl}permiso/`;
headers:any = {'Content-Type': 'application/json', 'Authorization': 'Bearer '+localStorage.getItem('token')};
```

- Agregamos los métodos
```ts
permisos(): Observable<any> {
    const url = `${this.url}lista-permisos?user=${localStorage.getItem('token')}`;
    return new Observable(observer => {
      axios.get(url, {
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

has(vista: string): boolean {
    const permisos = JSON.parse(localStorage.getItem('permisos') || '[]');
    return permisos.includes(vista);
}
```

2. Utilizamos el servicio en el **login.page.ts** y **registro.page.ts**
```ts
this.permisoService.permisos().subscribe(
    async permisosResponse => {
        if (permisosResponse?.data) {
            await localStorage.setItem('permisos', JSON.stringify(permisosResponse.data));
        }
        this.router.navigate(['/tabs']);
    },
    error => {
        console.error('Error obteniendo permisos:', error);
        this.alertError();
    }
);
```

3. Creamos el guards **permiso**

- Creamos el guards, recuerda seleccionar **canActivate**
```ts
ionic g guard guard/permiso
```

- Agregamos dentro del guards
```ts
import { CanActivateFn, ActivatedRouteSnapshot, RouterStateSnapshot } from '@angular/router';
import { inject } from '@angular/core';
import { Router } from '@angular/router';
import { AlertController } from '@ionic/angular';

export const permisoGuard: CanActivateFn = async (route: ActivatedRouteSnapshot, state: RouterStateSnapshot): Promise<boolean> => {
  const router = inject(Router);
  const alertCtrl = inject(AlertController);

  const permisos = await localStorage.getItem('permisos');
  const token = localStorage.getItem('token');
  const vista = route.routeConfig?.path;
  console.log(vista);

  if (!token) {
    router.navigate(['/login']);
    return false;
  }

  if (permisos && vista && permisos.includes(vista)) {
    return true;
  }

  const alert = await alertCtrl.create({
    header: 'Acceso denegado',
    message: 'No tienes permiso para entrar a esta sección.',
    buttons: ['OK']
  });

  await alert.present();
  router.navigate(['/efpartido-list']);
  return false;
};
```

4. Maneras de utilizar los permisos

- En los **routing.modules.ts**
```ts
{
    path: 'tab2/:matricula',
    loadChildren: () => import('../tab2/tab2.module').then(m => m.Tab2PageModule),
    canActivate: [PermisoGuard]
},
```

- En los **botones** en las vistas
```ts
*ngIf="permisos.has('tab2/:matricula')"
```

5. Agregar el **Cerrar sesión**
- Agregamos en el **ts** de su preferencia
```ts
logout() {
    localStorage.clear();
    this.router.navigateByUrl('/', { replaceUrl : true });
}
```

- Manera de usarlo en el toolbar
```ts
<ion-button slot="end" (click)="logout()">
  <ion-icon name="log-out"></ion-icon>
</ion-button>
```
