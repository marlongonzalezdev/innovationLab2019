import { SkillCategory } from './skill-category';
export interface Skills {
    id: number;
    relatedId: number;
    category: SkillCategory;
    code: string;
    name: string;
    defaultExpertise: number;
}
