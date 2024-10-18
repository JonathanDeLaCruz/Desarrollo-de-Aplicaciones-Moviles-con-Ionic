# Eliminar elemento con Ionic

1. Agregamos en el ***page.html*** donde queremos eliminar el elemento

    `<ion-button (click)="alertEliminar(alumno.alu_matricula)" color="danger"><ion-icon name="trash"></ion-icon></ion-button>`

2. Configuramos en el ***page.ts***

    * Función de mensaje de confirmación para eliminar el elemento
    ```
    async alertEliminar(matricula: string) {
        const alert = await this.alertCtrl.create({
        header: 'Alumno',
        subHeader: 'Eliminar',
        message: '¿Estás seguro de eliminar al estudiante con matrícula ' + matricula + '?',
        cssClass: 'alert-center',
        buttons: [
            {
            text: 'Cancelar',
            role: 'cancel'
            },
            {
            text: 'Confirmar',
            role: 'confirm',
            handler: () => {
                this.eliminar(matricula);
            }
            }
        ]
        });
        await alert.present();
    }
    ```

    * Función que elimina el elemento
    ```
    async eliminar(matricula:string) {
        const response = await axios({
        method: 'delete',
        url: this.baseUrl + 's/' + matricula,
        withCredentials: true,
        headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer 100-token'
        }
        }).then((response) => {
        if (response?.status == 204) {
            this.alertEliminado(matricula, 'El alumno con matricula ' + matricula + ' ha sido eliminado');
        }
        }).catch(function (error) {
        console.log(error);
        });
    }
    ```

    * Función de alerta para avisar que se realizó la operación
    ```
    async alertEliminado(matricula: String, msg = "") {
        const alert = await this.alertCtrl.create({
        header: 'Alumno',
        subHeader: 'Eliminado',
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
                this.regresar();
            },
            },
        ],
        });

        await alert.present();
    }
    ```

    * Función para regresar y recargar la página de listado
    ```
    private regresar() {
        this.router.navigate(['/tabs/tab1']).then(() => {
        window.location.reload();
        });
    }
    ```

    * Agregar en las importaciones del ***page.ts***

    `import { Router } from '@angular/router';`
