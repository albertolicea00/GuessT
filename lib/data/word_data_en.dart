/// English word deck — the primary/canonical language. Every category id
/// declared in `categories.dart` must have an entry here; other language
/// files fall back to this one for any id they don't cover.
const Map<String, String> kCategoryNamesEn = {
  'animals': 'Animals',
  'movies': 'Movies',
  'series': 'TV Series',
  'objects': 'Objects',
  'historyScience': 'History & Science',
  'colorsShapes': 'Colors & Shapes',
  'animalsEasy': 'Animals (easy)',
};

const Map<String, List<String>> kCategoryWordsEn = {
  'animals': [
    'Lion', 'Elephant', 'Giraffe', 'Dolphin', 'Eagle', 'Penguin',
    'Crocodile', 'Kangaroo', 'Shark', 'Fox', 'Owl', 'Chameleon',
    'Rhinoceros', 'Octopus', 'Bat', 'Flamingo', 'Panda', 'Wolf',
  ],
  'movies': [
    'Titanic', 'The Matrix', 'Avatar', 'Rocky', 'Shrek', 'Gladiator',
    'Jumanji', 'Frozen', 'Coco', 'Joker', 'Barbie', 'Interstellar',
    'The Godfather', 'Jaws', 'Toy Story', 'Up', 'Dune', 'Encanto',
  ],
  'series': [
    'Friends', 'Breaking Bad', 'Money Heist', 'Stranger Things',
    'The Simpsons', 'Game of Thrones', 'The Office', 'Dark',
    'Peaky Blinders', 'Narcos', 'Loki', 'Rick and Morty',
    'Succession', 'Wednesday',
  ],
  'objects': [
    'Umbrella', 'Scissors', 'Bicycle', 'Watch', 'Camera', 'Guitar',
    'Mirror', 'Lamp', 'Backpack', 'Toothbrush', 'Key',
    'Chair', 'Hat', 'Ball', 'Ladder', 'Mug',
  ],
  'historyScience': [
    'French Revolution', 'Albert Einstein', 'DNA', 'Photosynthesis',
    'Roman Empire', 'Big Bang', 'World War II',
    'Marie Curie', 'Gravity', 'Renaissance', 'Vaccine', 'Independence',
    'Solar System', 'Periodic Table', 'Cold War', 'Democracy',
  ],
  'colorsShapes': [
    'Red', 'Circle', 'Square', 'Blue', 'Star', 'Triangle',
    'Yellow', 'Heart', 'Green', 'Sun', 'Moon', 'Cloud',
  ],
  'animalsEasy': [
    'Dog', 'Cat', 'Cow', 'Duck', 'Fish', 'Horse',
    'Sheep', 'Chicken', 'Rabbit', 'Pig', 'Frog', 'Bee',
  ],
};
