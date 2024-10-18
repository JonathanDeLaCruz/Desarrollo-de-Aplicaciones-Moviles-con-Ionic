# Actualizar elemento con Ionic

1. Modificamos el ***page.html*** donde pondremos el botón para actualizar

    `<ion-button (click)="editar(alumno.alu_matricula)" color="warning"><ion-icon name="pencil"></ion-icon></ion-button>`

2. Agregamos en el ***page.ts*** donde agregamos el botón

    ```
    async editar(matricula: string) {

        const paginaModal = await this.modalCrtl.create({
        component: NewPage,
        componentProps: {
            'matricula': matricula
        },
        breakpoints: [0, 0.3, 0.5, 0.95],
        initialBreakpoint: 0.95
        });
        await paginaModal.present();

        paginaModal.onDidDismiss().then((data) => {
            this.cargarAlumnos();
        });
    }
    ```

    Donde:

    * **matricula** es mi clave primaria y en el ejemplo es de tipo string.
    * **componentProps** agregamos la o las variables que necesita enviar a la página donde se encuentra nuestro formulario, recuerda la variable llegará con el nombre que se agregue entre comillas.
    * **onDidDismiss** es el evento que se efectua al cerrar un modal y dentro de el se agrega **this.cargarAlumnos();** para volver actualizar mi lista.

3. Agregamos en el ***page.ts*** donde se encuentra nuestro formulario

    `@Input() matricula: string | undefined;`

* **@Input()** Es un decorador que indica que la propiedad matricula puede recibir valores desde un componente padre. Esto significa que el componente que contiene esta propiedad (matricula) puede recibir valores desde otro componente a través de la sintaxis de enlace de datos de Angular.

    `carreraUrl: string = "http://clases.test/sws-carreras?per-page=50"`

* **per-page** es es un parámetro de consulta de Yii2 utilizado para controlar la cantidad de resultados que se deben mostrar por página al hacer una solicitud.

    `private editarDatos = [];`

* **editarDatos** es una variable donde guardaremos los datos que usaremos para rellenar el formulario.

	```
    ngOnInit() {
        this.cargarCarreras();
        if (this.matricula !== undefined) {
            this.getDetalles();
        }
        this.formulario();
    }
    ```

* **this.matricula !== undefined** validamos que si la matrícula está vacía, si está vacía es que estamos creando un nuevo registro, en caso contrario rellenamos el formulario.

    ```
    private formulario() {
        this.alumno = this.formBuilder.group({
        alu_matricula: ['', Validators.compose([
            Validators.required,
            Validators.minLength(8),
            Validators.maxLength(10),
            Validators.pattern("^[1|2][0-9]{7,9}$")
        ])],
        alu_nombre: ['', [Validators.required]],
        alu_paterno: ['', [Validators.required]],
        alu_materno: ['', [Validators.required]],
        alu_semestre: ['', Validators.compose([
            Validators.min(1),
            Validators.max(15),
            Validators.required,
        ])],
        alu_sexo: ['', [Validators.required]],
        alu_fkcarrera: ['', [Validators.required]],
        });
        if (this.matricula !== undefined) {
            this.alumno.get('alu_matricula')?.disable();
        }
    }
    ```
* **this.alumno.get('alu_matricula')?.disable();** de igual forma validamos si la matrícula no esta vacía, desactivo un campo con la propiedad **disable()**

    ```
    async guardarDatos() {
        try {
            const alumno: Alumno = this.alumno?.value;
            if (this.matricula === undefined) {
                const response = await axios({
                method: 'post',
                url: this.baseUrl,
                data: alumno,
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': 'Bearer 100-token'
                }
                }).then((response) => {
                    if (response?.status == 201) {
                        this.alertGuardado(response.data.alu_matricula, 'El alumno con matricula ' + response.data.alu_matricula + ' ha sido registrada');
                    }
                    }).catch((error) => {
                    if (error?.response?.status == 422) {
                        this.alertGuardado(alumno.alu_matricula, error?.response?.data[0]?.message, "Error");
                    }
                    if (error?.response?.status == 500) {
                        this.alertGuardado(alumno.alu_matricula, "No puedes eliminar porque tiene relaciones con otra tabla", "Error");
                    }
                });
            } else {
                const response = await axios({
                method: 'put',
                url: this.baseUrl + '/' + this.matricula,
                data: alumno,
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': 'Bearer 100-token'
                }
                }).then((response) => {
                    if (response?.status == 200) {
                        this.alertGuardado(response.data.alu_matricula, 'El alumno con matricula ' + response.data.alu_matricula + ' ha sido actualizado');
                    }
                    }).catch((error) => {
                    if (error?.response?.status == 422) {
                        this.alertGuardado(alumno.alu_matricula, error?.response?.data[0]?.message, "Error");
                    }
                });
            }
        } catch (e) {
            console.log(e);
        }
    }
    ```

* Modificamos la función **guardarDatos**, agregando una condición en base a si el valor que enviamos desde la vista principal enviamos la variable **matricula**, si viene llena, agregamos el metodo ***put*** donde es necesario enviar el id que queremos modificar.

* **error?.response?.status == 500** agregamos la validación del status ***500*** error que se efectua cuando se intenta eliminar un elemento que tiene relación con otra tabla, creando el error de consistencia de datos.

    ```
    async getDetalles() {
        const response = await axios({
        method: 'get',
        url: this.baseUrl + "/" + this.matricula,
        withCredentials: true,
        headers: {
            'Accept': 'application/json'
        }
        }).then((response) => {
            this.editarDatos = response.data;
            Object.keys(this.editarDatos).forEach((key: any) => {
                const control = this.alumno.get(String(key));
                if (control !== null) {
                    control.markAsTouched();
                    control.patchValue(this.editarDatos[key]);
                }
            })
        }).catch(function (error) {
            console.log(error);
        });
    }
    ```

* Usamos el metodo de **CargarElemento** manual donde se busca los datos especificos de un elemento, agregamos operaciones que realizarán la validación y agregarán al formulario los datos obtenidos.

* **Object.keys(this.editarDatos)** es una función de JavaScript que devuelve un array con los nombres de las propiedades de un objeto.

* **.forEach((key: any)** es un método de los arrays en JavaScript que ejecuta una función proporcionada una vez por cada elemento en el array. En este caso, se está utilizando para iterar sobre las claves (propiedades) del objeto this.editarDatos.

* **const control = this.alumno.get(String(key));** se utiliza para obtener una referencia al control del formulario correspondiente a la clave (propiedad) actual en la iteración.

* **if (control !== null)** Se verifica si el control del formulario obtenido no es nulo. Esto es importante para asegurarse de que existe un control en el formulario correspondiente a la clave actual del objeto this.editarDatos.

* **control.markAsTouched();** es un método en Angular que marca un control del formulario como "tocado", lo que significa que el usuario ha interactuado con ese control. Esto es útil para mostrar mensajes de error o estilos visuales indicando que el control ha sido modificado.

* **control.patchValue(this.editarDatos[key]);** patchValue() es un método en Angular que actualiza el valor de un control del formulario con un nuevo valor. En este caso, se está usando para asignar el valor correspondiente a la clave actual del objeto this.editarDatos al control del formulario.
