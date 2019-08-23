

import { Observable } from 'rxjs';
import { Skill } from 'src/app/shared/models/skill';

export abstract class SkillServiceBase {
    public baseUrl: string;
    public abstract getSkills: () => Observable<Skill[]>;
    public abstract getSkillById: (skill: Skill) => Observable<Skill>;
}
