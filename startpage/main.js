window.onload = function() {
}

var color_active   = "red";
var color_inactive = "cyan";

var active;

window.onkeypress = function(event) {
    var old_active = active;

    if      (event.key == "r") active = document.getElementById("reddit");
    else if (event.key == "t") active = document.getElementById("twitter");
    else if (event.key == "y") active = document.getElementById("youtube");
    else if (event.key == "s") active = document.getElementById("soundcloud");
    else if (event.key == "b") active = document.getElementById("blackboard");
    else if (event.key == "e") active = document.getElementById("email");
    else if (event.key == "c") active = document.getElementById("calendar");

    if ((old_active != null) && (active != old_active)) {
        old_active.className = color_inactive;
    }

    if (active != null) {
        active.className = color_active;

        if ((event.key == "Escape") || (event.key == "Backspace")) {
            active.className = color_inactive;
            active = null;
        }

        if (event.key == "Enter") {
            active.click();
        }
    }
}
