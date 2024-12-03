let fileContent;

document.addEventListener("DOMContentLoaded", () => {
    document.getElementById("calculate").setAttribute("disabled", "");
    document.getElementById('fileInput').addEventListener('change', function(event) {
        const file = event.target.files[0];
        if (file) {
        const reader = new FileReader();
        
        reader.onload = function(e) {
            fileContent = e.target.result;
            console.log(fileContent);
            document.getElementById("calculate").removeAttribute("disabled");
            document.getElementById("inputLabel").style.display = 'none';
        };
        
        reader.readAsText(file);

        } else {
        document.getElementById("inputLabel").style.display = 'block';
        document.getElementById("calculate").setAttribute("disabled", "");
        }
    });
});

function calculate() {
    document.getElementById("result").textContent = fileContent;
    console.log("test")
}