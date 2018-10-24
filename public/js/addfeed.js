$(function($) {
    $('#add-from').submit(function(event) {
        event.preventDefault();
        var $form = $(this);
        var $button = $form.find('button');

        $.ajax({
            url: $form.attr('action'),
            type: $form.attr('method'),
            data: $form.serialize(),
            timeout: 10000,
            
            beforeSend: function(xhr, settings) {
                $button.attr('disabled', true);
            },
            complete: function(xhr, textStatus) {
                $button.attr('disabled', false);
            },
            
            success: function(result, textStatus, xhr) {
                console.log(result["error_message"]);
                $form[0].reset();
                if (result["error_message"] == null) {
                   $('#result').text('登録しました');
                } else { 
                   $('#result').text(result["error_message"]);
                }

            },
            error: function(xhr, textStatus, error) {
                $('#result').text('登録失敗');
            }
        });
    });
    
    // デモ用に入力値を設定
    var $form = $('#the-form');
    $form.find('[name=name]').val('名無しさん');
    $form.find('[name=mail]').val('anonymouse@example.com');
    $form.find('[name=sex][value=male]').prop('checked', true);
    $form.find('[name=message]').val('こんにちはこんにちは！');
});
