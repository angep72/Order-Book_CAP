namespace sap.ui.riskmanagement;
using { managed } from '@sap/cds/common';

entity Risks : managed {
    key ID          : UUID;        // Unique ID for the Risk
    title           : String(110); // Title of the risk
    prio            : String(5);   // Priority (High, Medium, Low)
    descr           : String;      // Description of the risk
    miti            : Association to Mitigations; // Association to Mitigations (1 to N)
    impact          : Integer;     // Impact score (1-10)
    criticality     : Integer;     // Criticality score (1-10)
}

entity Mitigations : managed {
    key ID          : UUID;        // Unique ID for the Mitigation
    description     : String;      // Description of the mitigation
    owner           : String;      // Owner of the mitigation
    timeline        : String;      // Timeline for the mitigation
    risks           : Association to Risks on risks.ID = $self.ID; // Association to Risks (N to 1)
}
