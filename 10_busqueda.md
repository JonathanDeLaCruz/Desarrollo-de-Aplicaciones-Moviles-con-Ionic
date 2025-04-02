# Búsquedas en una lista

## Configuraciones en Yii2

1. Agregamos el controlador la función de buscar

```php
public function actionBuscar($text)
{
    $consulta = UserAlumno::find()->where(['like', new \yii\db\Expression("CONCAT(alu_matricula, ' ', alu_nombre, ' ', alu_paterno, ' ', alu_materno)"), $text]);

    $alumnos = new ActiveDataProvider([
        'query' => $consulta,
        'pagination' => [
            'pageSize' => 20 // Número de resultados por página
        ],
    ]);

    return $alumnos->getModels();
}
```

2. Modificamos en el controlador la función de total

```php
public function actionTotal($text)
{
    $total = UserAlumno::find();
    if($text != '') {
        $total = $total->where(['like', new \yii\db\Expression("CONCAT(alu_matricula, ' ', alu_nombre, ' ', alu_paterno, ' ', alu_materno)"), $text]);
    }
    $total = $total->count();
    return $total;
}
```

3. Modificamos las rules en el archivo web.php

```php
['class' => 'yii\web\UrlRule', 'pattern' => 'user-alumnos/buscar/<text:.*>', 'route' => 'user-alumno/buscar'],
['class' => 'yii\web\UrlRule', 'pattern' => 'user-alumnos/total/<text:.*>', 'route' => 'user-alumno/total'],
[
    'class'      => 'yii\rest\UrlRule',
    'controller' => 'user-alumno',
    'tokens' => [
        '{id}'   => '<id:\\d[\\d,]*>',
        '{text}' => '<text:\\w+>'
    ],
    'extraPatterns' => [
        'GET buscar/{text}' => 'buscar',
        'GET total/{text}'  => 'total'
    ],
],
```

## Configuraciones en Ionic

1. Agregamos en el page.ts las variables necesarias

```ts
busqueda:string = '';
```

2. Agregamos en el page.ts la función de handleInput

```ts
handleInput(event:any) {
  this.busqueda = event.target.value.toLowerCase();
  this.cargarAlumnos();
}
```

3. Modificamos la funcion cargarElementos()

```ts
async cargarAlumnos(event?: InfiniteScrollCustomEvent) {
    const loading = await this.loadingCtrl.create({
        message: 'Cargando',
        spinner: 'bubbles',
    });
    await loading.present();
    const response = await axios({
        method: 'get',
        url: enverioment.apiUrl + "user-alumno/buscar/"+this.busqueda,
        withCredentials: true,
        headers: {
            'Accept': 'application/json'
        }
    }).then((response) => {
        this.alumnos = response.data;
        event?.target.complete();
    }).catch(function (error) {
        console.log(error);     
    });
    loading.dismiss();
}
```

4. Agregamos en el page.html el componente ion-searchbar

```html
<ion-searchbar [debounce]="1000" (ionInput)="handleInput($event)" placeholder="Buscar..."></ion-searchbar>
```
