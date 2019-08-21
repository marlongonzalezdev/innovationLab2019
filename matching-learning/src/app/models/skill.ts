import { SkillCategory } from './skill-category';
export class Skill {
    id: number;
    relatedId: number;
    category: number;
    code: string;
    name: string;
    defaultExpertise: number;
    weight: number;
}
