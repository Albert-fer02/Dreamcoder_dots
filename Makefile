.PHONY: install test coverage build clean lint

install:
	pip install -e ".[dev]"

test:
	python -m pytest tests/ -v

coverage:
	python -m pytest tests/ --cov=dreamcoder_theme --cov-report=term-missing

build:
	python -m build

clean:
	rm -rf dist/ build/ *.egg-info/

lint:
	ruff check src/dreamcoder_theme/ tests/
