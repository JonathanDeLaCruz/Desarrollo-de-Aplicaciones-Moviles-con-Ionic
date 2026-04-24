# Listado de elementos con Ionic

## Yii2

1. Configuración en cada uno de los controladores que se encuentran en la ruta *proyecto/controllers*.

    ```php
    public function behaviors()
    {
        $behaviors = parent::behaviors();
        $behaviors['corsFilter'] = [
            'class' => \yii\filters\Cors::className(),
            'cors' => [
                'Origin'                           => ['http://localhost:8100'],
                'Access-Control-Request-Method'    => ['GET'],
                'Access-Control-Request-Headers'   => ['*'],
                'Access-Control-Allow-Credentials' => true,
                'Access-Control-Max-Age'           => 600
            ]
        ];
        return $behaviors;
    }
    ```
## Ionic

1. Instalar Axios: este comando solo se ejecuta una vez, en la consola en el proyecto de ionic

    `npm i axios`

    [Axios](https://axios-http.com/es/) es un cliente HTTP basado en promesas para Node.js y el navegador. Es isomórfico, lo que significa que puede ejecutarse en el navegador y en Node.js con el mismo código base. En el lado del servidor usa el módulo nativo HTTP de Node.js, mientras que en el lado del cliente (navegador) usa XMLHttpRequests.

2. Configurar en el archivo *tabla-listado.page.ts*
    * Agregamos en el **@Component**, al final de las líneas ya escritas, la propiedad de *standalone: false* como en el ejemplo; recuerda, no debes reemplazar, solo agregar la nueva propiedad.

    ```typescript
    @Component({
      selector: 'app-root',
      templateUrl: 'app.component.html',
      styleUrls: ['app.component.scss'],
      standalone: false,
    })
    ```
3. Agregamos las importaciones; recuerda que se agregan al inicio del archivo *tabla-listado.page.ts*
    
    * Importamos el componente **LoadingController**

        `import { LoadingController } from '@ionic/angular';`
    
    * Importamos la clase axios

        `import axios from 'axios';`
4. Configuración del constructor

    El [constructor](https://medium.com/zurvin/cu%C3%A1l-es-la-diferencia-entre-ngoninit-y-constructor-en-angular-2f7ce3d986b7) es propio de una clase en ECMAScript 6 y, por ende, JavaScript llama al constructor antes que a cualquier otro método. Esto significa que no es un buen lugar para indicarle a Angular que ha terminado de inicializar el componente. Es aquí donde podemos especificar qué dependencias necesitamos cargar.
    
    ```typescript
    constructor(
        private loadingCtrl: LoadingController,
    ) {}
    ```
5. Agregamos después del método constructor
    * Creamos un array para guardar los elementos.
    
    ```typescript
    alumnos: any = [];
    ```
6. Configuramos el **ngOnInit**

    ```typescript
    ngOnInit() {
        this.cargarAlumnos();
    }
    ```

7. Creamos la función asíncrona **cargarAlumnos**
    *url: "http://localhost:8080/tabla"* Recuerda la url necesita el nombre de la tabla.
    El nombre de la tabla debe ser en plural siempre; si tu tabla se llama categoria, debes poner categorias.También recuerda que para pluralizar solo se agrega una s al final, si ya está en plural la tabla, ya se queda así, por ejemplo: la tabla se llama productos, se queda exactamente igual.

    ```typescript
    async cargarAlumnos() {
        const loading = await this.loadingCtrl.create({
            message: 'Cargando',
            spinner: 'bubbles',
        });
        await loading.present();
        await axios({
            method: 'get',
            url: "http://localhost:8080/tabla",
            withCredentials: true,
            headers: {
                'Accept': 'application/json'
            }
        }).then((response) => {
            this.alumnos = response.data;
        }).catch(function (error) {
            console.log(error);     
        });
        loading.dismiss();
    }
    ```
8. Configuramos el **tabla-listado.page.html**

    ```html
    <ion-list>
        <ion-item button *ngFor="let alumno of alumnos">
        <ion-avatar slot="start">
            <img src="https://r-charts.com/es/miscelanea/procesamiento-imagenes-magick_files/figure-html/color-fondo-imagen-r.png" alt="Foto">
        </ion-avatar>

        <ion-label class="ion-text-wrap">
            <h3>{{alumno.alu_nombre}} {{alumno.alu_paterno}}  {{alumno.alu_materno}}</h3>
            <p>{{alumno.alu_nacimiento | date:'y-MM-dd'}}</p>
        </ion-label>
    
        <ion-badge slot="end">{{alumno.alu_curricular}}</ion-badge>
        </ion-item>
    </ion-list>
    ```

    * **ngFor** para iterar los elementos de nuestro array.
    * **{{}}** doble llave para imprimir valores de nuestro array.
    * **.** punto para seleccionar una propiedad de nuestro elemento seleccionado.
    * **slot** nos indica la posición de los componentes.
    * **| date:'y-MM-dd'** permite darle formato de fecha.
