# Menú

1. Modificamos el archivo app.component.ts, donde agregaremos todos los enlaces a los que querramos navegar.

```ts
enlaces:any = [
    { ruta: '/tabs/tab1', texto: 'Tab 1' },
    { ruta: '/tabs/tab2', texto: 'Tab 2' },
    { ruta: '/tabs/tab3', texto: 'Tab 3' },
    { ruta: '/tabs/nueva', texto: 'Nueva' },
    { ruta: '/tabs/tab1/siguiente', texto: 'Siguiente' }
];
```

2. Modificamos el app.component.html

```html
<ion-app>
  <!-- Menú lateral -->
  <ion-menu contentId="main">
    <ion-header>
      <ion-toolbar>
        <ion-title>Menú</ion-title>
      </ion-toolbar>
    </ion-header>

    <ion-content [fullscreen]="true">
      <ion-list>
        <ion-item *ngFor="let enlace of enlaces" [routerLink]="enlace.ruta" routerDirection="root">
          {{ enlace.texto }}
        </ion-item>
      </ion-list>
    </ion-content>
  </ion-menu>

  <!-- Contenido principal -->
  <ion-router-outlet id="main"></ion-router-outlet>
</ion-app>
```

3. Modificamos el app.component.css
```css
ion-menu {
    --width: 260px;
    box-shadow: 2px 0 8px rgba(0, 0, 0, 0.1);
}

ion-header {
    background: #3880ff;
    color: #fff;
}

ion-toolbar {
    --background: transparent;
    --color: #fff;
    text-align: center;
}

ion-title {
    font-weight: bold;
    font-size: 1.3rem;
}

ion-content {
    --padding-start: 0;
    --padding-end: 0;
    --padding-top: 0;
    --padding-bottom: 0;
}

ion-list {
    margin-top: 10px;
}

ion-item {
    --background: transparent;
    --color: #ffffff;
    font-size: 1.1rem;
    font-weight: 500;
    transition: background 0.2s ease;
}

ion-item:hover {
    --background: #e0e0e0;
    cursor: pointer;
}

ion-item::part(native) {
    padding-left: 20px;
}
```
