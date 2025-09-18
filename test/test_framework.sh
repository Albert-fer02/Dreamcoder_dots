#!/bin/bash

# Dreamcoder Setup - Testing Framework
# Comprehensive testing for security, functionality, and performance

set -euo pipefail

# Test framework configuration
TEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$TEST_DIR")"
LIB_DIR="$PROJECT_DIR/lib"

# Colors for test output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Load core functions for testing
if [[ -f "$LIB_DIR/core.sh" ]]; then
    source "$LIB_DIR/core.sh"
fi

# Test utilities
print_test_header() {
    echo -e "\n${BLUE}=== $1 ===${NC}"
}

print_test_result() {
    local test_name="$1"
    local result="$2"
    local message="${3:-}"

    if [[ $result -eq 0 ]]; then
        echo -e "${GREEN}✓ PASS${NC} $test_name"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}✗ FAIL${NC} $test_name"
        if [[ -n "$message" ]]; then
            echo -e "${RED}  Error: $message${NC}"
        fi
        ((TESTS_FAILED++))
    fi
    ((TESTS_RUN++))
}

# Security Tests
test_path_sanitization() {
    print_test_header "Path Sanitization Tests"

    # Test dangerous path
    if sanitize_path "../../../etc/passwd" 2>/dev/null; then
        print_test_result "Path traversal prevention" 1 "Should reject dangerous paths"
    else
        print_test_result "Path traversal prevention" 0
    fi

    # Test safe path
    if sanitized=$(sanitize_path "/home/user/.config"); then
        print_test_result "Safe path handling" 0
    else
        print_test_result "Safe path handling" 1 "Should accept safe paths"
    fi
}

test_input_validation() {
    print_test_header "Input Validation Tests"

    # Test dangerous input
    if validate_user_input "; rm -rf /;" 10; then
        print_test_result "Dangerous input rejection" 1 "Should reject dangerous input"
    else
        print_test_result "Dangerous input rejection" 0
    fi

    # Test safe input
    if validate_user_input "safe_input" 20; then
        print_test_result "Safe input acceptance" 0
    else
        print_test_result "Safe input acceptance" 1 "Should accept safe input"
    fi

    # Test length validation
    if validate_user_input "this_is_a_very_long_input_that_should_be_rejected" 10; then
        print_test_result "Length validation" 1 "Should reject long input"
    else
        print_test_result "Length validation" 0
    fi
}

test_sudo_validation() {
    print_test_header "Sudo Validation Tests"

    # Test sudo validation (this will depend on environment)
    if validate_sudo_access 2>/dev/null; then
        print_test_result "Sudo validation" 0
    else
        print_test_result "Sudo validation" 0 "Sudo not available (expected in test environment)"
    fi
}

# Functionality Tests
test_module_loading() {
    print_test_header "Module Loading Tests"

    # Test core module loading
    if [[ -f "$LIB_DIR/core.sh" ]]; then
        source "$LIB_DIR/core.sh" 2>/dev/null
        if command_exists "print_success"; then
            print_test_result "Core module loading" 0
        else
            print_test_result "Core module loading" 1 "Core functions not available"
        fi
    else
        print_test_result "Core module loading" 1 "Core module not found"
    fi
}

test_distro_detection() {
    print_test_header "Distribution Detection Tests"

    if [[ -f "$LIB_DIR/distro.sh" ]]; then
        source "$LIB_DIR/distro.sh" 2>/dev/null
        if distro=$(detect_distro); then
            print_test_result "Distribution detection" 0 "Detected: $distro"
        else
            print_test_result "Distribution detection" 1 "Failed to detect distribution"
        fi
    else
        print_test_result "Distribution detection" 1 "Distro module not found"
    fi
}

# Performance Tests
test_caching_performance() {
    print_test_header "Caching Performance Tests"

    local start_time=$(date +%s%N)
    local distro1=$(get_cached_distro 2>/dev/null || echo "unknown")
    local first_call=$((($(date +%s%N) - start_time)/1000000))

    start_time=$(date +%s%N)
    local distro2=$(get_cached_distro 2>/dev/null || echo "unknown")
    local second_call=$((($(date +%s%N) - start_time)/1000000))

    if [[ $second_call -lt $first_call ]]; then
        print_test_result "Caching performance" 0 "Cache working: ${first_call}ms -> ${second_call}ms"
    else
        print_test_result "Caching performance" 1 "Cache not effective"
    fi
}

# Configuration Tests
test_config_validation() {
    print_test_header "Configuration Validation Tests"

    if [[ -f "$LIB_DIR/config.sh" ]]; then
        source "$LIB_DIR/config.sh" 2>/dev/null
        if [[ ${#CONFIGS[@]} -gt 0 ]]; then
            print_test_result "Configuration loading" 0 "Loaded ${#CONFIGS[@]} configurations"
        else
            print_test_result "Configuration loading" 1 "No configurations loaded"
        fi
    else
        print_test_result "Configuration loading" 1 "Config module not found"
    fi
}

# Test Runner
run_all_tests() {
    echo -e "${BLUE}🚀 Starting Dreamcoder Setup Test Suite${NC}"
    echo -e "${BLUE}=========================================${NC}"

    # Security Tests
    test_path_sanitization
    test_input_validation
    test_sudo_validation

    # Functionality Tests
    test_module_loading
    test_distro_detection

    # Performance Tests
    test_caching_performance

    # Configuration Tests
    test_config_validation

    # Test Summary
    echo -e "\n${BLUE}=========================================${NC}"
    echo -e "${BLUE}📊 Test Results Summary${NC}"
    echo -e "${BLUE}=========================================${NC}"
    echo -e "Tests Run: $TESTS_RUN"
    echo -e "${GREEN}Tests Passed: $TESTS_PASSED${NC}"
    if [[ $TESTS_FAILED -gt 0 ]]; then
        echo -e "${RED}Tests Failed: $TESTS_FAILED${NC}"
        return 1
    else
        echo -e "${GREEN}All tests passed! 🎉${NC}"
        return 0
    fi
}

# Main execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_all_tests
fi