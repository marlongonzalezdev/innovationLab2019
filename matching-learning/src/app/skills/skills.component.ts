import { Component, OnInit } from '@angular/core';


export interface Skill {
  value: string;
  viewValue: string;
  expectedScore: number;
}


@Component({
  selector: 'app-skills',
  templateUrl: './skills.component.html',
  styleUrls: ['./skills.component.css']
})
export class SkillsComponent implements OnInit {
  skills: Skill[] = [];

  skillList: Skill[] = [
    { value: '1', viewValue: 'C#', expectedScore: undefined },
    { value: '2', viewValue: 'SQL', expectedScore: undefined },
    { value: '3', viewValue: 'Java', expectedScore: undefined },
    { value: '3', viewValue: 'Elastic Search', expectedScore: undefined },
    { value: '3', viewValue: 'Kotlin', expectedScore: undefined },
    { value: '3', viewValue: 'Angular', expectedScore: undefined },
    { value: '3', viewValue: 'React', expectedScore: undefined},
    { value: '3', viewValue: 'Javascript', expectedScore: undefined },
  ];

  selectedSkill: Skill;
  expectedScore: number;

  constructor() { }

  ngOnInit() {
  }

  add(skill: Skill): void {

    if (!skill || !this.expectedScore) { return; }
    if (!this.skills.find(s => s === skill)) {
      skill.expectedScore = this.expectedScore;
      this.skills.push(skill);
      this.selectedSkill = undefined;
      this.expectedScore = undefined;
    }
  }

  delete(name: string): void {

  }

}
