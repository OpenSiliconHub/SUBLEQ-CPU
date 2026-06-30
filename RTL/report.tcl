# ============================================================================
# Dynamic Verification Report & Smart Gatekeeper
# ============================================================================

# Total $equiv cells in the design (proven + unproven)
set total_cells [yosys select -count t:\$equiv]

# Run plain equiv_status (no -assert, so it never aborts the script) and
# redirect its log output to a file so we can parse the proven/unproven
# counts out of it ourselves.
set logfile "equiv_status_report.log"
yosys tee -q -o $logfile equiv_status

# Read the captured log and look for the summary line, e.g.:
#   "Of those cells 4112 are proven and 0 are unproven."
set fh [open $logfile r]
set log_text [read $fh]
close $fh

set unproven_count 0
if {[regexp {are proven and (\d+) are unproven} $log_text -> n]} {
    set unproven_count $n
}
set status_failed [expr {$unproven_count > 0}]

# Format integers with commas for high-scannability displays
proc format_num {num} {
    while {[regsub {^([-+]?\d+)(\d{3})} $num {\1,\2} num]} {}
    return $num
}
set fmt_violations [format_num $unproven_count]
set fmt_metrics    [format_num $total_cells]

puts ""
puts "======================================================================"
puts "                 BEHAVIORAL VERIFICATION REPORT                       "
puts "======================================================================"

if {!$status_failed} {
    puts "  \[+\] Status:            PASSED"
    puts "  \[+\] Match Quality:     100% Behavioral Equivalence Proven"
    puts "  \[+\] Violations:        0 Mismatches Detected"
} else {
    puts "  \[!\] Status:            FAILED"
    puts "  \[!\] Match Quality:     MISMATCH (Behavioral logic pathways diverge)"
    puts "  \[!\] Violations:        $fmt_violations Faulty Bits Located"
}

puts "  \[+\] Mode:              FULL (Comprehensive Structural Evaluation)"
puts "  \[+\] Metrics:          $fmt_metrics Active Proof Elements Monitored"
puts "  \[+\] Languages:         Verilog-2005 vs VHDL-1993"
puts "======================================================================"
puts ""

# AUTOMATION SAFEGUARD: Force Yosys/Tcl to terminate with an exit error code
# if any behavioral mismatches exist.
if {$status_failed} {
    error "Formal Equivalence Verification Failed with $fmt_violations unproven bits!"
}
