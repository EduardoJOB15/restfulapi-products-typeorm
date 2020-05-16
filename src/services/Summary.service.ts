import {Request, Response} from "express";
import {getConnection} from "typeorm";
import {fact_summary,IResult} from "../entity/Summary.entity";

export class SummaryService{

    public async getSummary(req:Request, res: Response){
        const summaries: fact_summary[] = await getConnection().getRepository(fact_summary).find({ where: {CustomerID: req.params.id} });
        res.status(200).json(summaries);
    }

}