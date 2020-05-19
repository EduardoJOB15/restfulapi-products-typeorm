import {Request, Response} from "express";
import {getConnection} from "typeorm";
import {fact_summary,IResult, ISummary} from "../entity/Summary.entity";

export class SummaryService{

    public async fullSummary(req:Request, res: Response){
        const result : IResult[] = await getConnection().query(`EXEC example.SP_FULIAR_SUMMARY`);
        res.status(200).json();
    }

    public async getSummary(req: Request, res: Response){
        const summarys = await getConnection().getRepository(fact_summary).find({where: {CustomerID: req.params.id}});
        res.status(200).json(summarys);
    }

}