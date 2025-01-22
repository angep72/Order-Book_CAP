namespace sap.ui.riskmanagement;
using {managed} from '@sap/cds/common';

entity Risks:managed{
    key ID: UUID; @(Core.Computed: true)
    title: String(111);
    description: String(1111);
    probability: Integer;
    impact: Integer;
    status: String(111);
    owner: String(111);
    createdAt: DateTime;
    modifiedAt: DateTime;
    createdBy: String(111);
    modifiedBy: String(111);
}