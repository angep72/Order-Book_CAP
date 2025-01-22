using {sap.ui.riskmanagement as  my} from '../db/schema';

@path:'service/risk'
service RiskService {
    entity Risks as projection on my.Risks;
    entity Mitigations as projection on my.Mitigations;
    annotate Mitigations with @odata.draft.enabled;
}