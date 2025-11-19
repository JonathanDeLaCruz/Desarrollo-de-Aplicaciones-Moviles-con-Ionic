# Insertar elementos en tablas de muchos a muchos con Ionic

1. Configurar en el archivo *page.ts*
    * Importar FormArray
    ```typescript
    import { FormBuilder, FormControl, FormGroup, Validators, FormArray } from '@angular/forms';
    ```

    * Nuevas variables
    ```typescript
    public materias: any[] = [];
    public materiasCargadas = false;
    ```

    * Inyectar el servicio de materias
    ```typescript
    private materiasService: MateriasService,
    private alumnoMateriaService: AlumnoMateriaService
    ```

    * Modificamos el método formulario() para añadir materias
    ```typescript
    materias: this.formBuilder.array([]),
    ```

   * Getter para el FormArray
    ```typescript
    get materiasFA(): FormArray {
       return this.alumno.get('materias') as FormArray;
     }
    ```

    * Métodos para añadir / quitar selects de materias
    ```typescript
    agregarMateria() {
        this.materiasFA.push(new FormControl(null, Validators.required));
    }

    eliminarMateria(index: number) {
        this.materiasFA.removeAt(index);
    }
    ```

    * Métodos para cargar Materias
    ```typescript
    async cargarMaterias() {
        try {
            await this.materiasService.listado('?per-page=100').subscribe(
                response => {
                    this.materias = response;
                    this.materiasCargadas = true;
                },
                error => {
                    console.error('Error materias:', error);
                }
            );
        } catch (error) {
            console.log(error);
        }
    }
    ```

    * En el ngOnInit solo añadimos la llamada
    ```typescript
    this.cargarMaterias();
    ```

    * Creamos el método de Guardar Materias
    ```typescript
    private guardarMaterias(matricula: string) {
        const materiasSeleccionadas: number[] = this.materiasFA.value.filter((id: any) => id != null && id !== '');

        if (!materiasSeleccionadas.length) {
            return;
        }

        materiasSeleccionadas.forEach(matId => {
            this.alumnoMateriaService.crear({
                alumat_fkalumno: matricula,
                alumat_fkmateria: matId
            }).subscribe(
                resp => console.log('Materia guardada', resp),
                err  => console.error('Error guardando materia', err)
            );
        });
    }
    ```

    * Dentro del subscribe de éxito, llamas a un método guardarMaterias(matricula) que usa el FormArray para crear los registros en alumno_materia.
    ```typescript
    const matriculaCreada = response.data.alu_matricula;
    this.guardarMaterias(matriculaCreada);
    ```

1. Configuramos el **page.html**

    ```html
    <ion-col size="12" *ngIf="materiasCargadas">
        <ion-item lines="none">
            <ion-label color="primary">Materias</ion-label>
            <ion-button size="small" (click)="agregarMateria()"> Agregar materia</ion-button>
        </ion-item>

        <div formArrayName="materias">
            <ion-item *ngFor="let matCtrl of materiasFA.controls; let i = index">
                <ion-label position="floating" color="primary">Materia {{ i + 1 }}</ion-label>
                <ion-select [formControlName]="i" class="form-control">
                    <ion-select-option *ngFor="let materia of materias" [value]="materia.mat_id">{{ materia.mat_nombre }}</ion-select-option>
                </ion-select>
                <ion-button fill="clear" color="danger" (click)="eliminarMateria(i)"><ion-icon name="trash"></ion-icon></ion-button>
            </ion-item>
        </div>
    </ion-col>
    ```
