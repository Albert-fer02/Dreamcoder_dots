# test_helper.bash — common setup for bats tests
# Source this in each test file: setup() { load test_helper; }

setup_file() {
    export PROJECT_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
    export SCRIPTS_DIR="${PROJECT_ROOT}/scripts"
}

setup() {
    if [[ ! -d "$SCRIPTS_DIR" ]]; then
        echo "ERROR: scripts directory not found at $SCRIPTS_DIR" >&2
        return 1
    fi
}
