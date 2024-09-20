# Listado de elementos con Ionic

1. Configuración en cada uno de los controladores de Yii2.

    ```
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

2. Instalar axios 

    `npm i axios`

    [Axios](https://axios-http.com/es/) es un Cliente HTTP basado en promesas para node.js y el navegador. Es isomórfico (= puede ejecutarse en el navegador y nodejs con el mismo código base). En el lado del servidor usa el módulo nativo http de node.js, mientras que en el lado del cliente (navegador) usa XMLHttpRequests.

3. Configurar en el archivo *page.ts*
    * Importamos el componente **LoadingController**

        `import { InfiniteScrollCustomEvent, LoadingController } from '@ionic/angular';`
    
    * Importamos la clase axios

        `import axios from 'axios';`
    
    * Configuración del constructor

    El [constructor](https://medium.com/zurvin/cu%C3%A1l-es-la-diferencia-entre-ngoninit-y-constructor-en-angular-2f7ce3d986b7) es propio de una clase en EcmaScript6 y por ende JavaScript llama al constructor antes que a ninguno, lo que significa que no es un buen lugar para ‘avisarle’ a angular que ha terminado de inicializar el componente. Es aquí, dentro del constructor, donde podemos aprovechar y decirle qué dependencias necesitamos cargar.
    
    ```
    constructor(
        private loadingCtrl : LoadingController,
    ) {}
    ```

    * Creamos un array para guardar los elementos.
    
    ```
    alumnos:any = [];
    ```
    * Configuramos el ngOnInit

    ```
    ngOnInit() {
        this.cargarAlumnos();
    }
    ```

    * Creamos la función asíncrona **CargarAlumnos**

    ```
    async cargarAlumnos(event?: InfiniteScrollCustomEvent) {
        const loading = await this.loadingCtrl.create({
            message : 'Cargando',
            spinner : 'bubbles',
        });
        await loading.present();
        const response = await axios({
            method: 'get',
            url : "http://clases.test/user-alumno",
            withCredentials: true,
            headers: {
                'Accept': 'application/json'
            }
        }).then( (response) => {
            this.alumnos = response.data;
            event?.target.complete();
        }).catch(function (error) {
            console.log(error);     
        });
        loading.dismiss();
    }
    ```
4. Configuramos el **page.html**

    ```
    <ion-list>
        <ion-item button *ngFor="let alumno of alumnos">
        <ion-avatar slot="start">
            <img src="assets/img/{{alumno.alu_sexo}}.png" alt="Foto">
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
