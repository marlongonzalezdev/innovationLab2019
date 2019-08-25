


import { Observable } from 'rxjs';
import { FormGroup } from '@angular/forms';
import { SkillCategory } from '../models/skill-category';
import { Skill } from '../models/skill';

export abstract class SkillServiceBase {
    public baseUrl: string;
    public form: FormGroup;
    public abstract getSkills: () => Observable<Skill[]>;
    public abstract getSkillById: (skill: Skill) => Observable<Skill>;
    public abstract getSkillCategory: () => Observable<SkillCategory>;
    public abstract saveSkill: (skill: Skill) => Observable<Skill>;
    public abstract InitializeFormGroup: () => void;
}
