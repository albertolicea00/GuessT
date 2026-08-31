/// Spanish word deck. Any category id missing here falls back to English
/// (see `word_repository.dart`) — keep this in sync with `word_data_en.dart`
/// when adding a new category.
const Map<String, String> kCategoryNamesEs = {
  'animals': 'Animales',
  'movies': 'Películas',
  'series': 'Series',
  'objects': 'Objetos',
  'historyScience': 'Historia y Ciencia',
  'colorsShapes': 'Colores y Formas',
  'animalsEasy': 'Animales (fácil)',
  'numbers': 'Números',
};

const Map<String, List<String>> kCategoryWordsEs = {
  'animals': [
    'León', 'Elefante', 'Jirafa', 'Delfín', 'Águila', 'Pingüino',
    'Cocodrilo', 'Canguro', 'Tiburón', 'Zorro', 'Búho', 'Camaleón',
    'Rinoceronte', 'Pulpo', 'Murciélago', 'Flamenco', 'Oso panda', 'Lobo',
  ],
  'movies': [
    'Titanic', 'Matrix', 'Avatar', 'Rocky', 'Shrek', 'Gladiador',
    'Jumanji', 'Frozen', 'Coco', 'Joker', 'Barbie', 'Interstellar',
    'El Padrino', 'Jaws', 'Toy Story', 'Up', 'Dune', 'Encanto',
  ],
  'series': [
    'Friends', 'Breaking Bad', 'La Casa de Papel', 'Stranger Things',
    'Los Simpson', 'Game of Thrones', 'The Office', 'Dark',
    'Peaky Blinders', 'El Chavo', 'Narcos', 'Loki',
    'Rick and Morty', 'Succession', 'Wednesday',
  ],
  'objects': [
    'Paraguas', 'Tijeras', 'Bicicleta', 'Reloj', 'Cámara', 'Guitarra',
    'Espejo', 'Lámpara', 'Mochila', 'Cepillo de dientes', 'Llave',
    'Silla', 'Sombrero', 'Balón', 'Escalera', 'Taza',
  ],
  'historyScience': [
    'Revolución Francesa', 'Albert Einstein', 'ADN', 'Fotosíntesis',
    'Imperio Romano', 'Big Bang', 'Segunda Guerra Mundial',
    'Marie Curie', 'Gravedad', 'Renacimiento', 'Vacuna', 'Independencia',
    'Sistema Solar', 'Tabla Periódica', 'Guerra Fría', 'Democracia',
  ],
  'colorsShapes': [
    'Rojo', 'Círculo', 'Cuadrado', 'Azul', 'Estrella', 'Triángulo',
    'Amarillo', 'Corazón', 'Verde', 'Sol', 'Luna', 'Nube',
  ],
  'animalsEasy': [
    'Perro', 'Gato', 'Vaca', 'Pato', 'Pez', 'Caballo',
    'Oveja', 'Gallina', 'Conejo', 'Cerdo', 'Rana', 'Abeja',
  ],
  'numbers': [
    'Uno', 'Dos', 'Tres', 'Cuatro', 'Cinco',
    'Seis', 'Siete', 'Ocho', 'Nueve', 'Diez',
  ],
};
