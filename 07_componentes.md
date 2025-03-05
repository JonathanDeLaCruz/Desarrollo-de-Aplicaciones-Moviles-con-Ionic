# Creación de Componentes

1. Creamos un nuevo componente con el comando:

```typescript
ionic g component components/toolbar
```

2. Creamos dentro de la carpeta de nuestro componente el archivo `toolbar.module.ts`:

```typescript
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { IonicModule } from '@ionic/angular';
import { ToolbarComponent } from './toolbar.component';

@NgModule({
  declarations: [ToolbarComponent],
  imports: [
    CommonModule,
    IonicModule
  ],
  exports: [ToolbarComponent]
})
export class ToolbarModule {}
```

3. Agregamos la variable `nombre` en el archivo `component.ts`, que nos servirá para cambiar dinámicamente el texto en el toolbar:

```typescript
@Input('nombre') nombre: string | undefined;
```

El decorador `@Input()` se utiliza para pasar datos desde un componente padre a un componente hijo. Es decir, permite que un componente hijo reciba valores desde su componente padre de manera dinámica.

4. Modificamos el archivo `component.html`:

```html
<ion-header [translucent]="true">
  <ion-toolbar>
    <ion-buttons slot="start">
      <ion-menu-button></ion-menu-button>
    </ion-buttons>
    <ion-title>{{ nombre }}</ion-title>
  </ion-toolbar>
</ion-header>
```

5. Nuestro componente está listo para ser usado. Es importante identificar el nombre del selector.

**Nota:** Este código es solo un ejemplo para identificar el nombre del selector, en este caso:

**app-toolbar**

```typescript
import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-toolbar',  // <-- Nombre del selector
  templateUrl: './toolbar.component.html',
  styleUrls: ['./toolbar.component.scss'],
  standalone: false
})
export class ToolbarComponent {

  @Input('nombre') nombre: string | undefined;

  constructor() { }

}
```

6. Utilizamos el componente desde el archivo `page.html` de nuestra elección:

```html
<app-toolbar nombre="Ejemplo"></app-toolbar>
```

7. Agregamos en el archivo `module.ts` la importación del `ToolbarModule`:

```typescript
import { IonicModule } from '@ionic/angular';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Tab1Page } from './tab1.page';
import { ExploreContainerComponentModule } from '../explore-container/explore-container.module';
import { Tab1PageRoutingModule } from './tab1-routing.module';
import { ToolbarModule } from '../component/toolbar/toolbar.module';

@NgModule({
  imports: [
    IonicModule,
    CommonModule,
    FormsModule,
    ExploreContainerComponentModule,
    Tab1PageRoutingModule,
    ToolbarModule  // <-- Agregamos el nuevo módulo aquí
  ],
  declarations: [Tab1Page]
})
export class Tab1PageModule {}
```
