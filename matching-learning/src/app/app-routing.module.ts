import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import {SkillsComponent} from './components/skills/skills.component';

const routes: Routes = [
  {path: 'build', component: SkillsComponent}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
