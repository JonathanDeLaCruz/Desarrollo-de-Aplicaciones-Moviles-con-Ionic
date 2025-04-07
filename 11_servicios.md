# Servicios

1. Creamos nuestro servicio con el siguiente comando

```ts
ionic g service services/alumnos
```

2. Agregamos las variables necesarias

```ts
url:string  = `${environment.apiUrl}user-alumnos`;
headers:any = {'Content-Type': 'application/json', 'Authorization': 'Bearer '+localStorage.getItem('token') || 'Bearer 100-token'};
```

3. Creamos los métodos para el correcto funcionamiento del servicio

- Listado de elementos

```ts
listado(extra: string = '', busqueda:string=''): Observable<any> {
    let url:string = '';
    if(busqueda === '') {
        url = `${this.url}`+extra;
    } else {
        url = `${this.url}/buscar/`+busqueda+extra;
    }
    return new Observable(observer => {
        axios.get(url, {
            withCredentials: true,
            headers: this.headers
        })
        .then(response => {
            observer.next(response.data);
            observer.complete();
        })
        .catch(error => {
            observer.error(error);
            observer.complete();
        });
    });
}
```

- Detalle de un elemento

```ts
detalle(matricula:string | null = '', extra:string = ''): Observable<any> {
    const url = `${this.url}/`+matricula+extra;
    return new Observable(observer => {
        axios.get(url, {
            withCredentials: true,
            headers: this.headers
        })
        .then(response => {
            observer.next(response.data);
            observer.complete();
        })
        .catch(error => {
            observer.error(error);
            observer.complete();
        });
    });
}
```

- Crear un elemento

```ts
crear(alumno: any): Observable<any> {
    const url = `${this.url}`;
    return new Observable(observer => {
      axios.post(url, alumno, {
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

- Actualizar un elemento

```ts
actualizar(matricula:string, alumno: any): Observable<any> {
    const url = `${this.url}/${matricula}`;
    return new Observable(observer => {
      axios.put(url, alumno, {
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

- Eliminar un elemento

```ts
eliminar(matricula: string): Observable<any> {
    const url = `${this.url}/${matricula}`;
    return new Observable(observer => {
      axios.delete(url, {
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

- Contar el total de elementos

```ts
total(busqueda:string=''): Observable<any> {
    const url = `${this.url}/total/`+busqueda;
    return new Observable(observer => {
      axios.get(url, {
        withCredentials: true,
        headers: this.headers
      })
      .then(response => {
        observer.next(response.data);
        observer.complete();
      })
      .catch(error => {
        observer.error(error);
        observer.complete();
      });
    });
}
```

4. Uso de los servicios en los page.ts

- Listado de elementos

```ts
async cargarAlumnos() {
    const loading = await this.loading.create({
      message: 'Cargando',
      spinner: 'bubbles',
    });
    await loading.present();
    try {
      await this.alumnoService.listado('?page='+this.page+'&fields=alu_sexo,alu_nombre,alu_paterno,alu_materno,alu_matricula&expand=carrera', this.busqueda).subscribe(
        response => {
          this.alumnos = response;
          this.cargarTotal();
        },
        error => {
          console.error('Error:', error);
        }
      );
    } catch (error) {
      console.log(error);
    }
    loading.dismiss();
}
```

- Detalle de un elemento

```ts
async cargarAlumno() {
    const matricula = this.route.snapshot.paramMap.get('matricula');
    const loading = await this.loading.create({
      message: 'Cargando',
      spinner: 'bubbles',
    });
    await loading.present();
    try {
      await this.alumnoService.detalle(matricula, '?expand=carrera').subscribe(
        response => {
          this.alumno = response;
        },
        error => {
          console.error('Error:', error);
        }
      );
    } catch (error) {
      console.log(error);
    }
    loading.dismiss();
}
```

- Crear y actualizar un elemento

```ts
async guardarDatos() {
    try {
      const alumno = this.alumno?.value;
      if (this.matricula === undefined) {
        try {
          await this.alumnoService.crear(alumno).subscribe(
            response => {
              if (response?.status == 201) {
                this.alertGuardado(response.data.alu_matricula, 'El alumno con matricula ' + response.data.alu_matricula + ' ha sido registrada');
              }
            },
            error => {
              if (error?.response?.status == 422) {
                this.alertGuardado(alumno.alu_matricula, error?.response?.data[0]?.message, "Error");
              }
              if (error?.response?.status == 500) {
                this.alertGuardado(alumno.alu_matricula, "No puedes eliminar porque tiene relaciones con otra tabla", "Error");
              }
            }
          );
        } catch (error) {
          console.log(error);
        }
      } else {
        try {
          await this.alumnoService.actualizar(this.matricula, alumno).subscribe(
            response => {
              console.log(response)
              if (response?.status == 200) {
                this.alertGuardado(response.data.alu_matricula, 'El alumno con matricula ' + response.data.alu_matricula + ' ha sido actualizado');
              }
            },
            error => {
              if (error?.response?.status == 422) {
                this.alertGuardado(alumno.alu_matricula, error?.response?.data[0]?.message, "Error");
              }
            }
          );
        } catch (error) {
          console.log(error);
        }
      }
    } catch (e) {
      console.log(e);
    }
}
```

- Eliminar un elemento

```ts
async eliminar(matricula: string) {
    try {
      await this.alumnoService.eliminar(matricula).subscribe(
        response => {
          this.alertEliminado(matricula, 'El alumno con matricula ' + matricula + ' ha sido eliminado');
        },
        error => {
          console.error('Error:', error);
          if (error.response?.status == 204) {
            this.alertEliminado(matricula, 'El alumno con matricula ' + matricula + ' ha sido eliminado');
          }
          if (error.response?.status == 500) {
            this.alertEliminado(matricula, 'No puedes eliminar porque tiene relaciones con otra tabla', 'Error');
          }
        }
      );
    } catch (error) {
      console.log(error);
    }
}
```

- Contar total de elementos

```ts
async cargarTotal() {
    try {
      await this.alumnoService.total(this.busqueda).subscribe(
        response => {
          this.totalAlumnos = response;
        },
        error => {
          console.error('Error:', error);
        }
      );
    } catch (error) {
      console.log(error);
    }
}
```
