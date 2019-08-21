import { Skill } from '../../../models/skill';

import { Observable } from 'rxjs';

export abstract class SkillServiceBase {
    public baseUrl: string;
    public abstract getSkills: () => Observable<Skill[]>;
    public abstract getSkillById: (skill: Skill) => Observable<Skill>;
}
