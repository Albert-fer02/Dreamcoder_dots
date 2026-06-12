package trainer

type Module struct {
	ID        int
	Name      string
	Keys      []string
	Lessons   []Lesson
	BossFight BossFight
}

type Lesson struct {
	ID       int
	Name     string
	Task     string
	Expected string
	Hint     string
}

type BossFight struct {
	Name  string
	Tasks []Lesson
}

func GetModule1() Module {
	return Module{
		ID:   1,
		Name: "Horizontal Movement",
		Keys: []string{"w", "e", "b", "f", "t", "0", "$", "^"},
		Lessons: []Lesson{
			{ID: 1, Name: "Word Forward", Task: "Move to next word start", Expected: "w", Hint: "Press w to jump to next word start"},
			{ID: 2, Name: "Word End", Task: "Move to end of word", Expected: "e", Hint: "Press e to jump to word end"},
			{ID: 3, Name: "Word Back", Task: "Move to previous word", Expected: "b", Hint: "Press b to jump back"},
			{ID: 4, Name: "Find Char", Task: "Find character 'f' forward", Expected: "ff", Hint: "Press f then the character"},
			{ID: 5, Name: "Till Char", Task: "Till character 't' forward", Expected: "ft", Hint: "Press t then the character"},
			{ID: 6, Name: "Line Start", Task: "Move to line start", Expected: "0", Hint: "Press 0 for column 0"},
			{ID: 7, Name: "Line End", Task: "Move to line end", Expected: "$", Hint: "Press $ for end of line"},
			{ID: 8, Name: "First Char", Task: "Move to first non-blank char", Expected: "^", Hint: "Press ^ for first non-blank"},
			{ID: 9, Name: "Word Combo 1", Task: "Go to next word end then back", Expected: "eb", Hint: "Combine e and b"},
			{ID: 10, Name: "Word Combo 2", Task: "Go forward two words", Expected: "ww", Hint: "Press w twice"},
			{ID: 11, Name: "Find and Move", Task: "Find 'x' then go to line end", Expected: "fx$", Hint: "Combine f and $"},
			{ID: 12, Name: "Back and Forward", Task: "Go back a word then forward two", Expected: "bww", Hint: "Combine b, w, w"},
			{ID: 13, Name: "Line Navigation", Task: "Go to start, then end, then start", Expected: "0$0", Hint: "Combine 0 and $"},
			{ID: 14, Name: "Complex Combo", Task: "Back word, find char, line end", Expected: "bf($", Hint: "Combine b, f, (, $"},
			{ID: 15, Name: "Mastery Test", Task: "Navigate to specific position", Expected: "w^e$", Hint: "Use all movement keys"},
		},
		BossFight: BossFight{
			Name: "Code Maze",
			Tasks: []Lesson{
				{ID: 100, Name: "Navigate to function", Task: "Use w, e, b to reach the function name", Expected: "web"},
				{ID: 101, Name: "Find opening paren", Task: "Use f to jump to specific char", Expected: "f("},
				{ID: 102, Name: "Line boundaries", Task: "Use 0 and $ to navigate line", Expected: "0$"},
			},
		},
	}
}
