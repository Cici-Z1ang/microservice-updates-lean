import MicroserviceUpdates

-- These commands are consumed by `scripts/verify.sh` and make the trust
-- boundary visible in the build log.
#print axioms MicroserviceUpdates.progressLt_wellFounded
#print axioms MicroserviceUpdates.rewrite_induction_reaches_atomic
#print axioms MicroserviceUpdates.rewrite_framework_update_consistent
#print axioms MicroserviceUpdates.Examples.MultiplierAdapter.synthesis_result
#print axioms MicroserviceUpdates.Examples.MultiplierAdapter.generatedTranslation_forwardCompatible
#print axioms MicroserviceUpdates.Examples.MultiplierAdapter.certifiedAdapter

