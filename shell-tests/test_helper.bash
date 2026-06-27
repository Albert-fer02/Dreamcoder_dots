# test_helper.bash — common setup for bats tests
# Source in each test file: setup() { load test_helper; }

PROJECT_ROOT="$(cd "${BATS_TEST_FILENAME%/*}/.." && pwd)"
SCRIPTS_DIR="${PROJECT_ROOT}/scripts"
export PROJECT_ROOT SCRIPTS_DIR

setup() {
    if [[ ! -d "$SCRIPTS_DIR" ]]; then
        echo "ERROR: scripts directory not found at $SCRIPTS_DIR" >&2
        return 1
    fi
}
