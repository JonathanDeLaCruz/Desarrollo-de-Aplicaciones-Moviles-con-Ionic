# Detalles de un elemento con Ionic

1. Configuramos el page.html desde donde queremos navegar a la otra página.

    ```
    <ion-button [routerLink]="['/tab2', alumno.alu_matricula]">
      <ion-icon name="person-circle"></ion-icon>
    </ion-button>
    ```
  * Agregamos la propiedad **[routerLink]** que nos permitira indicará:
    * ***'/tab2'*** la página a donde queremos navegar
    * ***alumno.alu_matricula*** es el parámetro que usaremos para realizar el filtrado en la nueva petición, debe ser la llave primaria.

2. Configuramos el routing.module.ts

    ```
    {
      path: 'tab2/:matricula',
      loadChildren: () => import('./tab2/tab2.module').then(m => m.Tab2PageModule)
    },
    ```
  * Recordemos que si la ruta va a ser global lo agregamos al archivo app.routing.module.ts, en el caso de que la ruta solo se pueda acceder desde una página en especifico, debemos añadirlo en el routing.module.ts de la page seleccionada.
  * El path consta de 2 propiedades:
    * ***tab2/*** la página a donde queremos navegar
    * ***:matricula*** es indispensable los **:** y se especifica el nombre del parámetro a utilizar en el page.ts destinatario.

3. Configuramos el archivo destinatario page.ts y agregamos lo siguiente:

  * Importamos los componentes necesarios

    ```
      import { ActivatedRoute } from '@angular/router';
      import { LoadingController } from '@ionic/angular';
      import axios from 'axios';
    ```

  * Añadimos las clases al constructor

    ```
      constructor(
        private route: ActivatedRoute,
        private loading : LoadingController
      ) { }
    ```

  * Declaramos la variable donde guardaremos el objeto que nos dará de respuesta **axios**

    `alumno: any = null;`

  * Modificamos ngOnInit

    ```
      ngOnInit(): void {
        this.cargarAlumno();
      }
    ```

  * Agregamos el método **cargarAlumno()**

    ```
      async cargarAlumno() {
        const matricula = this.route.snapshot.paramMap.get('matricula');
        const loading = await this.loading.create({
          message: 'Cargando',
          spinner: 'bubbles',
        });
        await loading.present();
        const response = await axios({
          method: 'get',
          url: "http://clases.test/user-alumnos/"+matricula+"?expand=carrera",
          withCredentials: true,
          headers: {
            'Accept': 'application/json'
          }
        }).then((response) => {
          this.alumno = response.data;
        }).catch(function (error) {
          console.log(error);
        });
        loading.dismiss();
      }
    ```
    * Obtenemos el valor enviado como un parámetro con ayuda del componente Route
      `const matricula = this.route.snapshot.paramMap.get('matricula');`
    *  Agregamos en la petición get de axios el parámetro para solo pedir el objeto específico y agregamos una **s** después del nombre de nuestro controlador para no escribir en la URL el **id**
      `url: "http://clases.test/user-alumnos/"+matricula+"?expand=carrera",`

4. Modificamos la page.html

  * Agregamos el siguiente código

    ```
      <ion-card *ngIf="alumno as alumno">
        <div class="center">
          <img src="assets/img/{{alumno.alu_sexo}}.png" alt="Foto">
        </div>
        <ion-card-header class="center">
          <ion-card-title>
            <h3>{{ alumno.alu_nombre }} {{ alumno.alu_paterno }} {{ alumno.alu_materno }}</h3>
          </ion-card-title>
        </ion-card-header>
        <ion-card-content>
          <ion-list>
            <ion-item>
              <ion-label>
                <p>Matrícula</p>
                <h2>{{ alumno.alu_matricula }}</h2>
              </ion-label>
            </ion-item>
            <ion-item>
              <ion-label>
                <p>Carrera</p>
                <h2>{{ alumno.carrera }}</h2>
              </ion-label>
            </ion-item>
            <ion-item>
              <ion-label>
                <p>Fecha de Nacimiento</p>
                <ion-icon name="calendar-number"></ion-icon>
                <h2 *ngIf="alumno.alu_nacimiento === null || alumno.alu_nacimiento === ''; else condicionFalsa">Sin Fecha de Nacimiento</h2>
                <ng-template #condicionFalsa>
                  {{alumno.alu_nacimiento | date:'y-MM-dd'}}
                </ng-template>
              </ion-label>
            </ion-item>
            <ion-item>
              <ion-label>
                <p>Semestre</p>
                <h2>{{ alumno.alu_semestre }}</h2>
              </ion-label>
            </ion-item>
          </ion-list>
        </ion-card-content>
      </ion-card>
    ```
    * **ngIf** para condicionar un elemento.
    * **else** se encuentra dentro de las opciones de **ngIf** y se indica un identificador, que será usado en la etiqueta ***<ng-template #identificador>*** donde se agrega el valor falso de la condición.
    * **?** signo de interrogación que cierra para anular errores de existencia de un objeto o propiedad, indica que si no existe el elemento u objeto no imprima ningún valor.
    * **(click)** propiedad que me permite agregar eventos de click, ejecuta una función existe en el page.ts

5. Agregamos la propiedad **(click)**

    * page.ts

    ```
      abrirPagina() {
        window.open("https://sws.villahermosa.tecnm.mx/", '_blank');
      }
    ```

    * page.html

    ```
      <ion-footer>
        <ion-button expand="full" (click)="abrirPagina()" *ngIf="alumno?.alu_matricula">
          <ion-icon name="arrow-redo-circle"></ion-icon>
          Abrir SWS
        </ion-button>
      </ion-footer>
    ```
6. Agregamos el botón de regresar, en el componente **ion-toolbar**

    * page.html

    ```
      <ion-buttons slot="start">
        <ion-back-button defaultHref=""></ion-back-button>
      </ion-buttons>
    ```
