import Foundation

struct Cultura {
    let nombre: String
    let region: String
    let descripcion: String
    let imagen: String
    let creditoImagen: String
    let urlImagen: URL

    static let ejemplos: [Cultura] = [
        Cultura(
            nombre: "Chavín",
            region: "Áncash · Sierra central",
            descripcion: "Chavín de Huántar fue un centro ceremonial de los Andes peruanos. Sus plazas, galerías interiores y esculturas de piedra muestran la importancia de la religión y del arte simbólico en esta cultura.",
            imagen: "chavin",
            creditoImagen: "Foto: Dtarazona / Wikimedia Commons · CC BY-SA 3.0",
            urlImagen: URL(string: "https://commons.wikimedia.org/wiki/File:Chavin_de_Huantar_El_Castillo_06122009.jpg")!
        ),
        Cultura(
            nombre: "Nasca",
            region: "Ica · Costa sur",
            descripcion: "La cultura Nasca se desarrolló en la costa sur del Perú. Es conocida por sus grandes líneas y geoglifos trazados en el desierto, así como por su cerámica policroma.",
            imagen: "nazca",
            creditoImagen: "Foto: Unukorno / Wikimedia Commons · CC BY 3.0",
            urlImagen: URL(string: "https://commons.wikimedia.org/wiki/File:Nazca_Lines_Hummingbird_(cropped).jpg")!
        ),
        Cultura(
            nombre: "Moche",
            region: "La Libertad y Lambayeque · Costa norte",
            descripcion: "La cultura Moche floreció en la costa norte. Su cerámica, incluidos los huacos retrato, conserva escenas y rostros que ayudan a conocer la vida de sus habitantes.",
            imagen: "moche",
            creditoImagen: "Imagen: Art Institute of Chicago / Wikimedia Commons · CC0",
            urlImagen: URL(string: "https://commons.wikimedia.org/wiki/File:Portrait_Vessel_of_a_Ruler-2.jpg")!
        ),
        Cultura(
            nombre: "Paracas",
            region: "Ica · Costa sur",
            descripcion: "La cultura Paracas se desarrolló en los valles de Chincha, Pisco, Ica y Nasca. Sus textiles bordados destacan por sus colores, figuras y cuidadosa elaboración.",
            imagen: "paracas",
            creditoImagen: "Foto: Hiart / Wikimedia Commons · CC0",
            urlImagen: URL(string: "https://commons.wikimedia.org/wiki/File:Archaeological_fragments_from_Paracas,_Peru,_Honolulu_Museum_of_Art_4181.1.JPG")!
        ),
        Cultura(
            nombre: "Inca",
            region: "Cusco · Andes peruanos",
            descripcion: "La civilización inca tuvo su centro en Cusco y se extendió por los Andes. Machu Picchu es uno de sus legados arquitectónicos más reconocidos.",
            imagen: "inca",
            creditoImagen: "Foto: Michaellbrawn / Wikimedia Commons · CC BY-SA 4.0",
            urlImagen: URL(string: "https://commons.wikimedia.org/wiki/File:MachuPicchuPeru.jpg")!
        )
    ]
}
