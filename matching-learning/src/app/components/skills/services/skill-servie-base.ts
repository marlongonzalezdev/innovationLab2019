import { Skills } from './../../../models/skills';

import { Observable } from 'rxjs';

export abstract class SkillServiceBase {
    public baseUrl: string;
    public abstract getSkill: () => Observable<Skills[]>;
    public abstract getSkillById: (skill: Skills) => Observable<Skills>;
}
