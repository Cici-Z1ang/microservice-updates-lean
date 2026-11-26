#!/usr/bin/env bash
set -euo pipefail

project_dir="$(cd "$(dirname "$0")/.." && pwd)"
cd "$project_dir"

lake build 2>&1 | tee build.log
audit_file=MicroserviceUpdates/Audit.lean
lake env lean "$audit_file" 2>&1 | tee audit.log
expected_audit=$(sed -n "s/^#print axioms \\(.*\\)$/'\\1' does not depend on any axioms/p" "$audit_file")
if [[ -z "$expected_audit" ]] || ! diff -u <(printf '%s\n' "$expected_audit") audit.log; then
  echo "verification failed: unexpected axiom audit output" >&2
  exit 1
fi
lake exe adapterDemo | tee demo.log

if grep -RnE --include='*.lean' '(^|[^[:alnum:]_])(sorry|admit)([^[:alnum:]_]|$)' \
    MicroserviceUpdates MicroserviceUpdates.lean Main.lean lakefile.lean; then
  echo "verification failed: proof placeholder found" >&2
  exit 1
else
  scan_status=$?
  if [[ "$scan_status" -ne 1 ]]; then
    echo "verification failed: proof placeholder scan could not complete" >&2
    exit "$scan_status"
  fi
fi

echo "verification passed: build, axiom audit, demo, and placeholder scan"

