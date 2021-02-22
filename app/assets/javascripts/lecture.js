$( function() {
    var places = ['11','2','浜松町','江戸川'];
    $( '#name' ).autocomplete({
        autoFocus: true,  //テキストフィールドの値をフォーカスされたアイテムの値で置き換える
        source: places,  //サジェストのデータを呼び出す
        minLength: 1  //オートコンプリートが動作する文字数を指定
    });
  });