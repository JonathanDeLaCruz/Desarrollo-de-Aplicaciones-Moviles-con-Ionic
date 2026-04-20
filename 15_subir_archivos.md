# Subir Imagen desde Ionic hacia Yii2 API y Guardarla en Servidor

## Arquitectura del flujo

1. Usuario selecciona imagen desde Ionic.
2. Ionic envía archivo vía `POST multipart/form-data`.
3. Yii2 recibe archivo.
4. Yii2 guarda archivo en `web/imagenes/perfiles/`
5. Yii2 actualiza campo `per_foto`
6. Ionic muestra mensaje de éxito.

# Parte 1: Configuración en Yii2

## 1. Agregar rutas en UrlManager

```php
['class' => 'yii\web\UrlRule', 'pattern' => 'perfils/subir-foto/<id:\d+>', 'route' => 'perfil/subir-foto'],
```

```php
'extraPatterns' => [
    'POST subir-foto/{id}' => 'subir-foto',
],
```

## 2. Crear carpeta destino

`web/imagenes/perfiles/`

## 3. Imagen por defecto

- Campo `per_foto` permite NULL
- Valor default: `perfil.png`

Guardar imagen por defecto en:

`web/imagenes/perfiles/perfil.png`

Eliminar en el modelo la regla `required` de `per_foto`.

## 4. Modelo Yii2

```php
public $fotoArchivo;
```

```php
[['fotoArchivo'], 'file', 'skipOnEmpty' => true, 'extensions' => 'png, jpg, jpeg, pdf, doc, docx']
```

---

# Parte 2: Controlador Yii2

```php
public function actionSubirFoto($id)
{
    Yii::$app->response->format = Response::FORMAT_JSON;
    $model = Perfil::findOne(['per_id' => $id]);
    if (!$model) {
        return ['success' => false, 'message' => 'Registro no encontrado'];
    }
    $model->fotoArchivo = UploadedFile::getInstanceByName('foto');
    if (!$model->fotoArchivo) {
        return ['success' => false, 'message' => 'No se recibió ningún archivo'];
    }
    $carpeta = Yii::getAlias('@app/web/imagenes/perfiles/');
    if (!is_dir($carpeta)) {
        mkdir($carpeta, 0777, true);
    }
    $extension = $model->fotoArchivo->extension;
    $nombreArchivo = 'perfil_' . $model->per_id . '_' . time() . '.' . $extension;
    $rutaCompleta = $carpeta . $nombreArchivo;
    if ($model->fotoArchivo->saveAs($rutaCompleta)) {
        $model->per_foto = $nombreArchivo;
        if ($model->save(false)) {
            return [
                'success' => true,
                'message' => 'Archivo subido correctamente',
                'archivo' => $model->per_foto
            ];
        }
        return [
            'success' => false,
            'message' => 'El archivo se guardó, pero no se pudo actualizar la BD'
        ];
    }
    return ['success' => false, 'message' => 'No se pudo guardar el archivo'];
}
```

---

# Parte 3: Cambios en Ionic

## HTML (`crear.page.html`)

```html
<ion-col size="12">
  <ion-label position="floating" color="primary">Fotografía</ion-label>
  <input type="file" formControlName="foto" (change)="onFileSelected($event)" accept="image/*" />
</ion-col>
```

## TypeScript (`crear.page.ts`)

### Variable global

```ts
archivoSeleccionado:any;
```

### Seleccionar archivo

```ts
onFileSelected(event: any) {
  const file = event.target.files?.[0];
  if (file) {
    this.archivoSeleccionado = file;
  }
}
```

### Subir archivo

```ts
async subirFoto(per_id:number|undefined) {
  const formData = new FormData();
  formData.append('foto', this.archivoSeleccionado);
  try {
    await axios({
      method: 'post',
      url: this.baseUrl + '/subir-foto/' + per_id,
      data: formData,
      headers: {
        'Authorization': 'Bearer 100-token'
      }
    });
  } catch (error) {
    console.error(error);
  }
}
```

---

# Parte 4: Uso

## Crear usuario nuevo
```ts
this.subirFoto(response.data.per_id);
```

## Actualizar usuario
```ts
this.subirFoto(this.per_id);
```

---
