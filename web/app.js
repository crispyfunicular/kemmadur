function kemmadurApp() {
  return {
    screen: "setup",
    categories: [
      { key: "declencheurs", label: "Déclencheur + nom", desc: "da + tad = ?" },
      { key: "nom_adjectif", label: "Nom + adjectif", desc: "mamm + brav = ?" },
      { key: "articles", label: "Article + nom", desc: "ar + bro = ?" },
      { key: "article_nom_adj", label: "Article + nom + adjectif", desc: "ur + mamm + brav = ?" },
    ],
    selectedCategories: [],
    questionCount: 20,
    pool: [],
    quiz: {
      questions: [],
      index: 0,
      score: 0,
      answer: "",
      feedback: null,
      history: [],
    },

    get totalAvailable() {
      if (!window.FLASHCARDS) return 0;
      if (this.selectedCategories.length === 0) {
        return Object.values(window.FLASHCARDS).reduce((s, arr) => s + arr.length, 0);
      }
      return this.selectedCategories.reduce(
        (s, key) => s + (window.FLASHCARDS[key] || []).length, 0
      );
    },

    startSession() {
      if (!window.FLASHCARDS) return;
      const cats = this.selectedCategories.length > 0
        ? this.selectedCategories
        : this.categories.map(c => c.key);

      let pool = [];
      cats.forEach(key => {
        (window.FLASHCARDS[key] || []).forEach(([q, r]) => {
          pool.push({ question: q, answer: r, category: key });
        });
      });

      // Mélanger
      for (let i = pool.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [pool[i], pool[j]] = [pool[j], pool[i]];
      }

      const count = Math.min(Math.max(this.questionCount, 1), pool.length);
      this.quiz.questions = pool.slice(0, count);
      this.quiz.index = 0;
      this.quiz.score = 0;
      this.quiz.answer = "";
      this.quiz.feedback = null;
      this.quiz.history = [];
      this.screen = "quiz";

      this.$nextTick(() => {
        const input = document.getElementById("answer-input");
        if (input) input.focus();
      });
    },

    get currentQuestion() {
      return this.quiz.questions[this.quiz.index] || null;
    },

    get progress() {
      if (this.quiz.questions.length === 0) return 0;
      return ((this.quiz.index) / this.quiz.questions.length) * 100;
    },

    normalize(str) {
      return str.trim().toLowerCase().replace(/\s+/g, " ");
    },

    submitAnswer() {
      if (!this.quiz.answer.trim()) return;
      const correct = this.normalize(this.currentQuestion.answer);
      const given = this.normalize(this.quiz.answer);
      const isCorrect = given === correct;

      if (isCorrect) {
        this.quiz.score++;
      }

      this.quiz.feedback = {
        correct: isCorrect,
        expected: this.currentQuestion.answer,
      };

      this.quiz.history.push({
        question: this.currentQuestion.question,
        expected: this.currentQuestion.answer,
        given: this.quiz.answer.trim(),
        correct: isCorrect,
      });
    },

    nextQuestion() {
      this.quiz.index++;
      this.quiz.answer = "";
      this.quiz.feedback = null;

      if (this.quiz.index >= this.quiz.questions.length) {
        this.screen = "summary";
        return;
      }

      this.$nextTick(() => {
        const input = document.getElementById("answer-input");
        if (input) input.focus();
      });
    },

    handleKeydown(event) {
      if (event.key === "Enter") {
        if (this.quiz.feedback) {
          this.nextQuestion();
        } else {
          this.submitAnswer();
        }
      }
    },

    resetSession() {
      this.quiz = {
        questions: [],
        index: 0,
        score: 0,
        answer: "",
        feedback: null,
        history: [],
      };
      this.screen = "setup";
    },

    get scorePercent() {
      const total = this.quiz.questions.length;
      if (total === 0) return 0;
      return Math.round((this.quiz.score / total) * 100);
    },
  };
}
