import { FormGroup } from '@angular/forms';
import { SkillCategory } from './../../../models/skill-category';
import { Skills } from './../../../models/skills';

import { Observable } from 'rxjs';

export abstract class SkillServiceBase {
    public baseUrl: string;
    public form: FormGroup;
    public abstract getSkill: () => Observable<Skills[]>;
    public abstract getSkillById: (skill: Skills) => Observable<Skills>;
    public abstract getSkillCategory: () => Observable<SkillCategory>;
}
