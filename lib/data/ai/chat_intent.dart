/// The set of questions the rule-based assistant understands.
///
/// Matching order matters: more specific intents (skills, projects) are
/// checked before generic ones (about) so a question like "what are his
/// skills?" does not fall through to the generic greeting/about handler.
enum ChatIntent {
  greeting,
  whoIs,
  about,
  services,
  skills,
  education,
  experience,
  projects,
  projectCategories,
  techStack,
  tools,
  languages,
  achievements,
  certifications,
  strengths,
  careerObjective,
  name,
  location,
  contactEmail,
  contactPhone,
  contactSocial,
  resume,
  howToHire,
  assistantIdentity,
  thanks,
  yes,
  no,
  goodbye,
  outOfScope,
  notFound,
}

/// A single matching rule: one or more keyword groups, plus a flag to also
/// require a context word. All groups are optional (OR matching), but when
/// [requiresContext] is true the [context] terms must also be present.
class IntentRule {
  final List<List<String>> groups;
  final List<String> context;
  final bool requiresContext;

  const IntentRule(this.groups, {this.context = const [], this.requiresContext = false});
}

/// Mapping from intent to its matching rules.
///
/// Every group is a list of words; the group matches if any of its words
/// appears in the normalized question. An intent matches if any group matches
/// (plus, when required, any context word).
const Map<ChatIntent, IntentRule> kIntentRules = {
  ChatIntent.greeting: IntentRule([
    ['hello', 'hi', 'hey', 'salam', 'assalam', 'asalam', 'assalaam', 'salaam'],
    ['good morning', 'good afternoon', 'good evening', 'good night'],
  ]),
  ChatIntent.assistantIdentity: IntentRule([
    ['who are you', 'what are you', 'who r u', 'are you a bot', 'are you ai'],
    ['your name', 'whats your name', "what's your name"],
    ['what can you do', 'what do you do'],
    ['are you chatgpt', 'are you real', 'are you human'],
    ['is this ai', 'is this chatgpt'],
  ]),
  ChatIntent.whoIs: IntentRule([
    ['who is awais', 'who is aak', 'who is ahmad'],
    ['introduce awais', 'about awais', 'introduce yourself'],
    ['tell me about awais', 'tell me about aak', 'tell me about the developer'],
    ['awais kya hai', 'awais kaun hai'],
    ['tell me about him', 'tell me about this person'],
  ]),
  ChatIntent.about: IntentRule([
    ['about him', 'about aak', 'about awais', 'about the developer'],
    ['tell me more', 'more about', 'tell me something about'],
    ['his background', 'his profile', 'his introduction'],
  ]),
  ChatIntent.name: IntentRule([
    ['his name', 'your name', 'what is his name', "what's his name"],
    ['full name', 'real name'],
    ['name kya hai'],
  ]),
  ChatIntent.services: IntentRule([
    ['services', 'service'],
    ['what can he do', 'what does he offer', 'what does he provide'],
    ['his work', 'hire him for', 'business with him'],
    ['does he do web', 'does he make apps', 'can he build'],
    ['can he make', 'can he develop', 'does he develop'],
    ['do you provide', 'can you help me build', 'can you make'],
  ]),
  ChatIntent.skills: IntentRule([
    ['skills', 'skill'],
    ['what can he do', 'good at'],
    ['expert in', 'specialized in', 'specialise in'],
    ['technologies', 'tech he knows'],
    ['what is he good at'],
  ]),
  ChatIntent.education: IntentRule([
    ['education', 'study', 'studies', 'studied'],
    ['degree', 'university', 'college', 'bachelor', 'bscs', 'bs'],
    ['did he study', 'has he studied', 'what did he study'],
    ['academic'],
  ]),
  ChatIntent.experience: IntentRule([
    ['experience', 'experienced'],
    ['how long', 'years', 'year'],
    ['how many years', 'how much experience'],
    ['has he worked', 'has he been working'],
  ]),
  ChatIntent.projects: IntentRule([
    ['projects', 'project'],
    ['apps he made', 'apps he built', 'apps he developed'],
    ['what has he built', 'what has he developed', 'what did he build'],
    ['applications', 'apps'],
    ['his portfolio', 'his work'],
  ]),
  ChatIntent.projectCategories: IntentRule([
    ['types of projects', 'categories', 'category', 'kinds of apps'],
    ['what kind of apps', 'what type of apps', 'what apps'],
  ]),
  ChatIntent.techStack: IntentRule([
    ['tech stack', 'stack'],
    ['programming languages', 'language he uses'],
    ['dart', 'kotlin', 'java', 'react', 'python'],
    ['firebase', 'what technologies', 'what technology'],
    ['tools he uses', 'what tools'],
  ]),
  ChatIntent.tools: IntentRule([
    ['tools', 'tool'],
    ['what tools', 'what software he uses'],
    ['photoshop', 'premiere', 'github', 'android studio'],
  ]),
  ChatIntent.languages: IntentRule([
    ['languages', 'language'],
    ['speak', 'speaks'],
    ['urdu', 'english', 'arabic', 'punjabi'],
  ]),
  ChatIntent.achievements: IntentRule([
    ['achievements', 'achievement', 'accomplish'],
    ['awards', 'award'],
    ['what has he achieved', 'what did he achieve'],
    ['milestones', 'successes', 'winning'],
  ]),
  ChatIntent.certifications: IntentRule([
    ['certifications', 'certification', 'certified', 'certificate'],
    ['courses', 'course', 'training', 'trained'],
    ['udemy', 'javascript', 'hifz', 'hafiz'],
  ]),
  ChatIntent.strengths: IntentRule([
    ['strengths', 'strength', 'strong points'],
    ['good qualities', 'qualities', 'traits'],
  ]),
  ChatIntent.careerObjective: IntentRule([
    ['career objective', 'career goal', 'objective', 'goal'],
    ['future plans', 'his plans', 'what does he want'],
    ['career path', 'his aim', 'his mission'],
  ]),
  ChatIntent.location: IntentRule([
    ['where is he from', 'where does he live', 'where does he reside'],
    ['location', 'city', 'country', 'from pakistan', 'pakistan'],
    ['based in', 'where is he based'],
  ]),
  ChatIntent.contactEmail: IntentRule([
    ['email', 'mail', 'gmail', 'e-mail'],
    ['email address', 'mail address'],
  ]),
  ChatIntent.contactPhone: IntentRule([
    ['phone', 'number', 'whatsapp', 'whats app', 'wa'],
    ['call him', 'call me', 'contact number', 'mobile'],
  ]),
  ChatIntent.contactSocial: IntentRule([
    ['social media', 'social', 'profile'],
    ['instagram', 'facebook', 'linkedin', 'threads', 'snapchat', 'github link'],
    ['where can i follow', 'follow him', 'connect with him'],
    ['his handle', 'handles', 'username'],
  ]),
  ChatIntent.resume: IntentRule([
    ['resume', 'cv', 'curriculum'],
    ['download resume', 'see his resume'],
  ]),
  ChatIntent.howToHire: IntentRule([
    ['hire', 'hire him', 'contact him', 'get in touch'],
    ['reach him', 'reach out', 'talk to him'],
    ['work with him', 'collaborate', 'freelance'],
  ]),
  ChatIntent.thanks: IntentRule([
    ['thank', 'thanks', 'thank you', 'shukria', 'jazak'],
  ]),
  ChatIntent.yes: IntentRule([
    ['yes', 'yeah', 'yep', 'yup', 'sure', 'haan', 'ji haan'],
  ]),
  ChatIntent.no: IntentRule([
    ['no', 'nope', 'nah', 'na', 'not really'],
  ]),
  ChatIntent.goodbye: IntentRule([
    ['bye', 'goodbye', 'see you', 'talk later'],
    ['allah hafiz', 'khuda hafiz', 'good night'],
  ]),
  ChatIntent.outOfScope: IntentRule([
    ['help me', 'can you help me', 'i need help'],
    ['can you do', 'will you do', 'make me'],
    ['what is', 'what are', 'who is', 'who are', 'how do', 'how to'],
    ['what', 'who', 'when', 'where', 'why', 'how', 'which'],
  ]),
};

/// A single response template with up to [kMaxFillers] slots filled from the
/// knowledge base. If [fillers] is empty the template is a literal reply.
class ChatResponse {
  final String template;
  final List<String> fillers;
  final bool allowGreetingPrefix;

  const ChatResponse(this.template, {this.fillers = const [], this.allowGreetingPrefix = false});

  String render() {
    if (fillers.isEmpty) return template;
    var output = template;
    for (final filler in fillers) {
      output = output.replaceFirst('{0}', filler);
    }
    return output;
  }
}

const int kMaxFillers = 8;
