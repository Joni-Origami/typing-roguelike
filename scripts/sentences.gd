extends Node

var nouns = [
	"table ", "chair ", "tea ", "mug ", "computer ", "laptop ", "hedgehog ", "phone ",
	"shoe ", "slipper ", "leaf ", "glass ", "booklet ", "pottery ", "hand cream ",
	"book ", "flag ", "man ", "woman ", "enby ", "person ", "drum ", "nail polish ", "poster ",
	"paper ", "wii sports ", "origami ", "kitten ", "cat ", "dog ", "puppy ", "fox ", "snail ",
	"nintendo 3ds ", "deoderant ", "controller ", "prison warden ", "door ", "sloth ",
	"mountain climber ", "tire ", "guitar ", "mouse ", "rat ", "spray bottle ", "tintin ",
	"slinky ", "vaseline ", "lanyard ", "trouser leg ", "skirt ", "shirt ", "vampire ", "sun ",
	"daughter ", "son ", "follower ", "streamer ", "wire ", "USB stick ", "keychain ",
	"lost keys ", "pyjamas ", "scissors ", "flashcard ", "lamp ", "timer ", "magnet ",
	"scarf ", "bag ", "music festival ", "examiner " ,"lunatic ", "chicken ", "egg ",
	"tree ", "tie ", "dress ", "wii sports resort ", "pokemon ", "hair "
]

var adjectives = [
	"transgender ", "gay ", "tall ", "short ", "heavy ", "light ", "powerful ", "old ",
	"wet ", "decrepid ", "slippery ", "crumbling ", "broken ", "discoloured ", "pink ",
	"blue ", "red ", "green ", "grey ", "tired ", "folded ", "slimy ", "soft ",
	"angry ", "sticky ", "heated ", "crazy ", "cracked ", "sloppy ", "american ",
	"british ", "french ", "german ", "spanish ", "scottish ", "welsh ", "irish ",
	"purple ", "puzzled ", "confused ", "unusual ", "cold ", "warm ", "ace ",
	"straight ", "dissapointed ", "new ", "swanky ", "drunk ", "nonplussed ", "", #blank
	"young ", "fickle ", "idiotic ", "ridiculous ", "pointless ", "orange ",
	"hairy "
]

var verbs = [
	"steals ", "sings about ", "wants ", "runs alongside ", "punches ", "rips ", "pushes ", "drowns ",
	"agitates ", "annoys ", "pioneers ", "destroys ", "discovers ", "saves ", "growls at ", "barks at ",
	"meows at ", "yips at ", "snarls at ", "bites at ", "kisses ", "marries ", "hugs ", "confuses ",
	"pinches ", "kicks ", "licks ", "flicks at ", "throws a stone at ", "pulls at ", "frowns at ",
	"rubs ", "brawls with ", "holds ", "eats whole ", "sits on ", "flips ", "circles ",
	"encircles ", "repots ", "transmogrifies ", "snaps ", "manifests ", "expunges "
]

var adverbs = [
	"regrettably ", "quickly ", "light-heartedly ", "heavy-heartedly ", "speedily ", "smoothly ",
	"harshly ", "slowly ", "annoyedly ", "tiredly ", "energetically ", "sloppily ", "angrily ",
	"gaily ", "begrudgingly ", "happily ", "unfortunately ", "stupidly ", "lazily ", "", #blank
	"ultimately ", "loosely ", "thinly ", "boringly ", "unfortunately ", "undoubtedly "
]

var connectives = [
	"and ", "but ", "so ", "therefore "
]

var correct_sentence

func create_sentence() -> String:
	var created_sentence_list = [adjectives.pick_random() + nouns.pick_random() + 
	adverbs.pick_random() + verbs.pick_random() + adjectives.pick_random() + nouns.pick_random()]
	var created_sentence = ""
	for i in range(created_sentence_list.size()):
		created_sentence += created_sentence_list[i]
	created_sentence = created_sentence.strip_edges()
	return created_sentence
