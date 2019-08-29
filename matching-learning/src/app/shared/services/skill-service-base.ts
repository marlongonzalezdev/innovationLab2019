import { Skill } from 'src/app/shared/models/skill';



import { Observable } from 'rxjs';
import { FormGroup } from '@angular/forms';
import { SkillCategory } from '../models/skill-category';

export abstract class SkillServiceBase {
    public baseUrl: string;
    public form: FormGroup;
    public abstract getSkillsSorted: () => Observable<Skill[]>;
    public abstract getSkills: () => Observable<Skill[]>;
    public abstract getSkillById: (skill: Skill) => Observable<Skill>;
    public abstract getSkillCategory: () => Observable<SkillCategory>;
    public abstract getMainSkillCategory: () => Observable<SkillCategory>;
    public abstract saveSkill: (skill: Skill) => Observable<Skill>;
    public abstract initializeFormGroup: () => void;
    public abstract populateForm: (skill) => void;
}

