# Creación de Componente Paginación

## Modificaciones en Yii2

1. Creamos en el **controller**

```php
public function actionTotal($text) {
    $total = UserAlumno::find();
    if($text != '') {
        $total = $total->where(['like', new \yii\db\Expression("CONCAT(alu_matricula, ' ', alu_nombre, ' ', alu_paterno, ' ', alu_materno)"), $text]);
    }
    $total = $total->count();
    return $total;
}
```

2. Modificamos el archivo **web.php**

```php
['class' => 'yii\web\UrlRule', 'pattern' => 'user-alumnos/total/<text:.*>', 'route' => 'user-alumno/total'],
[
    'class'      => 'yii\rest\UrlRule',
    'controller' => 'user-alumno',
    'tokens' => [
        '{id}'   => '<id:\\d[\\d,]*>',
        '{text}' => '<text:\\w+>'
    ],
    'extraPatterns' => [
        'GET total'         => 'total',
    ],
],
```

# Creación de componente Paginación

1. Creamos un nuevo componente con el comando

```ts
ionic g component components/paginacion
```

2. Creamos dentro de la carpeta de nuestro componente el archivo paginacion.module.ts

```ts
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { IonicModule } from '@ionic/angular';
import { PaginacionComponent } from './paginacion.component';

@NgModule({
  declarations: [PaginacionComponent],
  imports: [
    CommonModule,
    IonicModule
  ],
  exports: [PaginacionComponent]
})
export class PaginacionModule {}
```

3. Agregamos las variables necesarias en el *component.ts* que nos servirá para cambiar dinamicamente los valores del componente

```ts
@ViewChild('swiperContainer') swiperContainer!: ElementRef;

paginas: number = 0;
activeIndex: number = 0;
paginacionItems: number[] = [];

@Input() total: number = 0;
@Input() slidesPerView: number = 6;
@Input() loop: boolean = false;
@Input() porPagina: number = 20;
```
## Explicación del código anterior

```ts
@ViewChild('swiperContainer') swiperContainer!: ElementRef;
```

- Busca un elemento HTML dentro del componente que tenga la referencia local `#swiperContainer`.
- `ElementRef` permite el acceso directo al DOM nativo de Angular, similar a `document.querySelector()`.

> **Ejemplo de HTML relacionado:**
> ```html
> <div #swiperContainer></div>
> ```

### Variables del componente

```ts
paginas: number = 0;
activeIndex: number = 0;
paginacionItems: number[] = [];
```

- `paginas`: almacena el total de páginas del carrusel. Se calcula dividiendo `total` entre `porPagina`.
- `activeIndex`: representa el índice actual del slide activo (por ejemplo, 0 para la primera página).
- `paginacionItems`: contiene un arreglo de números que puede usarse para generar los indicadores o botones de paginación.

### Inputs del componente

Estas propiedades son **configurables desde un componente padre**, usando property binding (`[propiedad]="valor"`).

```ts
@Input() total: number = 0;
@Input() slidesPerView: number = 6;
@Input() loop: boolean = false;
@Input() porPagina: number = 20;
```

### 🔹 `@Input() total: number = 0;`
- Número total de elementos a mostrar en el carrusel (por ejemplo, 50 imágenes o tarjetas).

### 🔹 `@Input() slidesPerView: number = 6;`
- Cantidad de slides visibles en pantalla al mismo tiempo.

### 🔹 `@Input() loop: boolean = false;`
- Si está en `true`, permite que el carrusel se reinicie automáticamente al llegar al final (efecto de loop infinito).

### 🔹 `@Input() porPagina: number = 20;`
- Define cuántos elementos hay por "página" lógica, útil para dividir el total en grupos manejables.

4. Agregamos las funciones en el ckass

### Función `inicializarSwiper()`

```ts
inicializarSwiper() {
  const mySwiper = new Swiper('.swiper-container', {
    centeredSlides: true,
    initialSlide: 0,
    loop: this.loop,
    allowSlidePrev: true,
    allowSlideNext: true,
    on: {
      slideChange: () => {
        let activeSlide = mySwiper.slides[0];
        let slideWidth = activeSlide.offsetWidth;
        let slidesPerView = (mySwiper.width / (slideWidth+10));
        let activeIndex = Math.trunc(mySwiper.slides.length / slidesPerView);
        if (mySwiper.activeIndex >= activeIndex) {
          mySwiper.allowSlideNext = false;
          mySwiper.slideTo(activeIndex)
        } else {
          mySwiper.allowSlideNext = true;
        }
      }
    }
  });
}
```
- **`Swiper('.swiper-container', {...})`**: Crea una nueva instancia de Swiper vinculada al contenedor con clase `.swiper-container`.
- **`centeredSlides: true`**: Centra el slide activo.
- **`initialSlide: 0`**: Comienza en el primer slide.
- **`loop: this.loop`**: Si se activa, permite desplazamiento infinito.
- **`slideChange` callback**:
  - Se ejecuta cuando cambia el slide.
  - Calcula cuántos slides caben en pantalla (`slidesPerView`).
  - Determina si se debe bloquear el avance (`allowSlideNext`) al final de los slides.
  - Usa `slideTo` para fijar la posición si se rebasa el final.

### `ngOnInit()`

```ts
ngOnInit() {
  this.inicializarSwiper();
}
```
- Se ejecuta una vez cuando se inicializa el componente.
- Llama a `inicializarSwiper()`.

### `ngAfterViewInit()`

```ts
ngAfterViewInit() {
  this.inicializarSwiper();
}
```
- Se llama después de que la vista y sus hijos han sido completamente inicializados.
- Vuelve a llamar a `inicializarSwiper()` para asegurar que el DOM esté listo (Swiper requiere que el contenedor exista en el DOM).

### `ngOnChanges()`

```ts
ngOnChanges() {
  this.paginas = Math.ceil(this.total / this.porPagina);
  this.paginacionItems = this.calcularPaginacionItems();
}
```
- Se ejecuta cuando cambian los inputs (`@Input()`).
- Calcula el número total de páginas (`paginas`).
- Genera los ítems de paginación (`paginacionItems`).

### Función `calcularPaginacionItems()`

```ts
calcularPaginacionItems(): number[] {
  const items: number[] = [];
  for (let i = 1; i <= this.paginas; i++) {
    items.push(i);
  }
  return items;
}
```
- Crea un arreglo con números del 1 al número total de páginas (`paginas`).
- Este arreglo puede ser usado para mostrar botones o indicadores de paginación.

### Función `onClickSlide(index: number)`

```ts
onClickSlide(index: number) {
  this.activeIndex = index;
}
```
- Se ejecuta al hacer clic en una paginación o slide.
- Cambia el índice activo del slide (`activeIndex`).

5. Modificamos el archivo *component.html*

```html
<div #swiperContainer class="swiper-container">
  <div class="swiper-wrapper">
    <div class="swiper-slide" *ngFor="let pag of paginacionItems; let i = index" (click)="onClickSlide(i)" [ngClass]="{'active': activeIndex === i}">
      {{ pag }}
    </div>
  </div>
</div>
```

6. Modificamos el archivo *component.scss*

```scss
.swiper-container {
  background-color: transparent;
  color: white;
  border: none;
  margin: 0 5px;
  padding: 8px 16px;
  transition: background-color 0.3s;
  text-align: center;
}

.swiper-slide {
  background-color: var(--ion-color-personalizado);
  width: 40px !important;
  height: 40px !important;
  border-radius: 50%;
  display: flex;
  justify-content: center;
  align-items: center;
  cursor: pointer;
  transition: transform 0.3s ease, width 0.3s ease, height 0.3s ease;
  margin: 0 5px;
}

.active {
  background-color: var(--ion-color-success);
}

.swiper-slide:active {
  transform: scale(1.2);
}
```

7. Utilizamos el componente desde mi **page.html** de mi elección

```ts
<app-paginacion [total]="total" (click)="pagina($event)"></app-paginacion>
```

8. Agregamos las siguientes funciones a mi **page.ts**

```ts
async cargarTotal() {
  const response = await axios({
      method: 'get',
      url : this.carreraUrl,
      withCredentials: true,
      headers: {
          'Accept': 'application/json'
      }
  }).then( (response) => {
      this.total = response.data;
  }).catch(function (error) {
      console.log(error);     
  });
}

pagina(event:any) {
  this.page = event.target.innerText;
  this.cargarAlumnos();
}
```

9.  Agregamos en el module.ts la importación del PaginacionModule

```ts
import { IonicModule } from '@ionic/angular';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Tab1Page } from './tab1.page';
import { ExploreContainerComponentModule } from '../explore-container/explore-container.module';

import { Tab1PageRoutingModule } from './tab1-routing.module';
import { PaginacionModule } from '../component/toolbar/toolbar.module';

@NgModule({
  imports: [
    IonicModule,
    CommonModule,
    FormsModule,
    ExploreContainerComponentModule,
    Tab1PageRoutingModule,
    PaginacionModule  // <-- Agregamos el nuevo módulo aquí
  ],
  declarations: [Tab1Page]
})
export class Tab1PageModule {}

```
