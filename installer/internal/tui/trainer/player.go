package trainer

type Player struct {
	XP          int                    `json:"xp"`
	Level       int                    `json:"level"`
	Title       string                 `json:"title"`
	Achievements []string              `json:"achievements"`
	Modules     map[int]ModuleProgress `json:"modules"`
}

type ModuleProgress struct {
	CompletedLessons []int       `json:"completed"`
	BestScores       map[int]int `json:"best_scores"`
	BossDefeated     bool        `json:"boss_defeated"`
}

func NewPlayer() *Player {
	return &Player{
		XP:      0,
		Level:   1,
		Title:   "Vim Beginner",
		Modules: make(map[int]ModuleProgress),
	}
}

func (p *Player) AddXP(amount int) {
	p.XP += amount
	p.updateLevel()
}

func (p *Player) updateLevel() {
	switch {
	case p.XP >= 2500:
		p.Level = 7
		p.Title = "Vim Sage"
	case p.XP >= 1500:
		p.Level = 6
		p.Title = "Vim Wizard"
	case p.XP >= 1000:
		p.Level = 5
		p.Title = "Vim Master"
	case p.XP >= 600:
		p.Level = 4
		p.Title = "Vim Expert"
	case p.XP >= 300:
		p.Level = 3
		p.Title = "Vim Journeyman"
	case p.XP >= 100:
		p.Level = 2
		p.Title = "Vim Apprentice"
	default:
		p.Level = 1
		p.Title = "Vim Beginner"
	}
}

func (p *Player) CompleteLesson(moduleID, lessonID int, score int, hintsUsed bool) {
	if _, ok := p.Modules[moduleID]; !ok {
		p.Modules[moduleID] = ModuleProgress{
			CompletedLessons: []int{},
			BestScores:       make(map[int]int),
		}
	}

	mod := p.Modules[moduleID]
	mod.CompletedLessons = append(mod.CompletedLessons, lessonID)

	if score > mod.BestScores[lessonID] {
		mod.BestScores[lessonID] = score
	}

	p.Modules[moduleID] = mod

	// XP rewards
	xp := 10
	if score == 100 && !hintsUsed {
		xp += 25 // Perfect bonus
	}
	p.AddXP(xp)
}
