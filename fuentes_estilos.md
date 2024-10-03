# Cambio de fuente y estilos a los componentes de Ionic

## Requisitos

* El formato de la fuente debe ser **.ttf**

[Fuente](https://fonts.google.com/)

## Configuración de fuente

1. Creamos la carpeta de font en **src > assets > font**

2. Copiamos el archivo **.ttf** en la carpeta ***font***

3. Configuramos el archivo **global.scss** agregamos el archivo **app.component.scss** para que los cambios afecten los estilos globales del proyecto.

    `@import "./app/app.component.scss";`

4. Configuramos la nueva fuente en el archivo **app > app.component.scss**

    ```
    @font-face {
        font-family: 'Young Serif';
        src: url("../assets/font/YoungSerif-Regular.ttf"); //change url accordingly
    }

    :root {
    --ion-font-family: 'Young Serif';
    }
    ```

    * **@font-face** es una regla css para especificar una fuente personalizada con la que mostrar texto.
    * **font-family** especifica un nombre que se utilizará como valor nominal de fuente para las propiedades de fuente.
    * **src** especifica la ruta por referencias a recursos de fuente.
    * **:root** es una pseudo-clase css que selecciona el elemento raíz de un árbol que representa el documento.
    * **--ion-font-family:** es la variable que contiene el nombre de la fuente por defecto.

## Configuración de los estilos

1. Los componentes de ionic cuentan con una propiedad **color** que es la encargada de darle los estilos de color dependiendo de la clase que se utilice.

    ```
    <ion-button>Default</ion-button>
    <ion-button color="primary">Primary</ion-button>
    <ion-button color="secondary">Secondary</ion-button>
    <ion-button color="tertiary">Tertiary</ion-button>
    <ion-button color="success">Success</ion-button>
    <ion-button color="warning">Warning</ion-button>
    <ion-button color="danger">Danger</ion-button>
    <ion-button color="light">Light</ion-button>
    <ion-button color="medium">Medium</ion-button>
    <ion-button color="dark">Dark</ion-button>
    ```

2. Creamos nuestra propia clase personalizada para cambiar los colores a los componentes en el archivo **app > app.component.scss**

    ```
    .ion-color-personalizado {
    --ion-color-base: #686090 !important;
    --ion-color-base-rgb: 104,96,144 !important;
    --ion-color-contrast: #ffffff !important;
    --ion-color-contrast-rgb: 255,255,255 !important;
    --ion-color-shade: #5c547f !important;
    --ion-color-tint: #77709b !important;
    }
    ```
    * Podemos usar [Color Generator](https://ionicframework.com/docs/theming/color-generator) para generar los colores.

3. Agregamos en nuestros componentes la nueva clase

    `<ion-button color="personalizado">Dark</ion-button>`
