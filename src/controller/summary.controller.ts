import {Application} from "express";
import {SummaryService} from "../services/Summary.service";

export class SummaryController{
    summary_service: SummaryService;
    constructor(private app: Application){
        this.summary_service = new SummaryService();
        this.routes();
    }
    private routes(){
        
        this.app.route("/summary/:id")
        .get(this.summary_service.getSummary);

    }
}