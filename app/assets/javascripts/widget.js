var loadWidgetContent= function(widget){
    var $widget = $(widget);
    var $widgetContent = $widget.find(".portlet-content");
    $.get($widgetContent.data('content-url'),{},function(content){
        $widgetContent.html(content)
    })
};

var loadWidgetContentIfVisible = function(widget) {
    var $widget = $(widget);
    var $widgetContent = $widget.find(".portlet-content");
    if ($widgetContent.is(":visible")) {
        loadWidgetContent(widget);
    }
};

var onFirstExpandWidget  = function(icon){
    var $icon = $(icon);
    var $widget = $icon.closest(".portlet");
    if (!$widget.find(".portlet-content").is(":visible")){
        var loadOnClick = function(){
            loadWidgetContent($widget);
            $icon.unbind("click", loadOnClick)
        }
        $icon.click(loadOnClick)
    }
};
var onToggleWidgetContent = function (icon) {
    var $icon = $(icon);
    var $widget = $icon.closest(".portlet");
    $icon.toggleClass("ui-icon-minusthick ui-icon-plusthick");
    $widget.find(".portlet-content").slideToggle(800);
    $.post($icon.data('update-url'), {
        id: $icon.data("widget_id"),
        state: $widget.find(".portlet-content").is(":visible")
    });
};