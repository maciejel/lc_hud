window.addEventListener("message", function (event) {
    var item = event.data
    switch (item.process) {
        case 'show':
            $('.speedometer').css({'transform': `translateY(0)`})
            // padStart(3, '0')
            let speed = Math.round(item.speedLevel).toString()
            $("#speed").html(speed.padStart(3, '0') + ' <span>MPH</span>')
            $("#fuelLevel").html(Math.round(item.fuel)+'%')
            $("#heading").text(item.heading)
            $("#street").text(item.streetName)

            $('.progressValue').css('width', Math.round(item.rpmLevel)+'%')
        break
        case 'hide':
            $('.speedometer').css({'transform': `translateY(500px)`})
        break
        case 'toggleCinemaMode':
            if(item.state == true) {
                $(".speedometer, .watermark").fadeIn(500)
                $(".cinema").fadeOut(500)
            } else {
                $(".cinema").fadeIn(500)
                $(".speedometer, .watermark").fadeOut(500)
            }
    }
})

window.onload = function() {
    $.post(`http://${GetParentResourceName()}/getPlayerId`, function(cb) {
        $('#playerId').html(cb)
    })
}