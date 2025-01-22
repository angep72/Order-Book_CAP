namespace sap.ui.riskmanagement;
using {managed} from '@sap/cds/common';

entity Risks:managed{
    key ID: UUID; @(Core.Computed: true)
    title: String(110);
    prio: String(5);
    descr: String;
    miti:Association to Mitigations;
    impact:Integer;
    criticality:Integer;

}