.PHONY: check

check:
	uv run --isolated --with pytest pytest -q
