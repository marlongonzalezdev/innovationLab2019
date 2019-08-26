import { SkillVersion } from './skillversion';
import { SkillCategory } from './skill-category';
export interface Skill {
    id: number;
    relatedId: number;
    category: SkillCategory;
    code: string;
    name: string;
    defaultExpertise: number;
    isVersioned: boolean;
    parentTechnologyId: number;
    versions: SkillVersion[];
    weight: number;
}
